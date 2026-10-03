import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flauncher/providers/update_service.dart';
import 'package:flauncher/updates/github_update_client.dart';
import 'package:flauncher/updates/update_release.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../updates/update_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences prefs;
  late FakeUpdateApi api;
  late FakeUpdateChannel bridge;
  late FakeDownloader downloader;
  late UpdateService service;
  var date = DateTime(2026, 10, 3);
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    api = FakeUpdateApi();
    bridge = FakeUpdateChannel();
    downloader = FakeDownloader();
    date = DateTime(2026, 10, 3);
    service = UpdateService(prefs,
        client: api,
        channel: bridge,
        downloader: downloader,
        now: () => date,
        startAutomatically: false);
    await service.initialized;
  });
  tearDown(() => service.dispose());
  test('daily automatic checks persist across restarts and never download',
      () async {
    await service.check();
    await service.check();
    expect(api.calls, 1);
    expect(service.available, isTrue);
    expect(downloader.downloads, 0);
    final restarted = UpdateService(prefs,
        client: api,
        channel: bridge,
        startAutomatically: false,
        now: () => date);
    await restarted.initialized;
    await restarted.check();
    expect(restarted.available, isTrue);
    expect(api.calls, 1);
    restarted.dispose();
    date = date.add(const Duration(days: 1));
    await service.check();
    expect(api.calls, 2);
  });
  test('manual checks ignore disabled automatic checks and daily cooldown',
      () async {
    await service.setAutomatic(false);
    await service.check();
    expect(api.calls, 0);
    await service.check(force: true);
    await service.check(force: true);
    expect(api.calls, 2);
  });
  test('offline errors keep cached update and back off requests', () async {
    await service.check();
    api.failure = const UpdateFailure('network');
    date = date.add(const Duration(days: 1));
    await service.check();
    await service.check();
    expect(api.calls, 2);
    expect(service.available, isTrue);
    expect(service.error, 'network');
  });
  test('concurrent requests are coalesced', () async {
    api.pending = Completer<UpdateRelease?>();
    final first = service.check(force: true);
    await Future<void>.delayed(Duration.zero);
    await service.check(force: true);
    expect(api.calls, 1);
    api.pending!.complete(api.value);
    await first;
  });
  test('debug builds never download or invoke the release installer', () async {
    service.dispose();
    bridge.debug = true;
    service = UpdateService(prefs,
        client: api,
        channel: bridge,
        downloader: downloader,
        startAutomatically: false);
    await service.check(force: true);
    await service.downloadAndInstall();
    expect(downloader.downloads, 0);
    expect(bridge.installs, 0);
  });
  test('explicit download sends expected build and hash to Android', () async {
    await service.check();
    await service.downloadAndInstall();
    expect(downloader.downloads, 1);
    expect(bridge.installs, 1);
    expect(bridge.lastDigest, 'a' * 64);
    expect(bridge.lastCode, 8113);
    expect(service.installerOpened, isTrue);
  });
  test('permission refusal keeps the verified download available for retry',
      () async {
    bridge.canInstall = false;
    await service.check();
    await service.downloadAndInstall();
    expect(service.error, 'permission');
    expect(service.ready, isTrue);
    await service.allowInstalls();
    expect(bridge.allows, 1);
    bridge.canInstall = true;
    await service.install();
    expect(bridge.installs, 2);
    expect(downloader.downloads, 1);
  });
  test('same/older builds and legacy releases are not downloadable', () async {
    for (final release in [
      nextRelease(code: 8112),
      nextRelease(code: 8111),
      UpdateRelease.fromJson(source())
    ]) {
      api.value = release;
      await service.check(force: true);
      await service.downloadAndInstall();
    }
    expect(downloader.downloads, 0);
    expect(bridge.installs, 0);
  });
}
