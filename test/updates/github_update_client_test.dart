import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flauncher/updates/github_update_client.dart';
import 'update_fixture.dart';

void main() {
  test('loads the public latest release then its update manifest', () async {
    final latest = source();
    latest['assets'].add({
      'name': 'update.json',
      'browser_download_url':
          'https://github.com/niposch/LTvLauncher-Extended/releases/download/v2026.10.02/update.json'
    });
    final http = FakeHttpClient([
      FakeResponse(jsonEncode(latest)),
      FakeResponse(jsonEncode(manifest()))
    ]);
    final release = await GitHubUpdateClient(createClient: () => http).latest();
    expect(release!.versionCode, 8113);
    expect(http.requested.first.path, endsWith('/releases/latest'));
    expect(http.requested.last.path, endsWith('/update.json'));
  });
  test('no releases and legacy releases are handled', () async {
    expect(
        await GitHubUpdateClient(
            createClient: () =>
                FakeHttpClient([FakeResponse('', statusCode: 404)])).latest(),
        isNull);
    final release = await GitHubUpdateClient(
        createClient: () =>
            FakeHttpClient([FakeResponse(jsonEncode(source()))])).latest();
    expect(release!.asset, isNull);
    expect(release.notes, contains('Home navigation'));
  });
  test('rate limiting and oversized metadata are reported', () async {
    for (final status in [403, 429]) {
      expect(
          GitHubUpdateClient(
                  createClient: () =>
                      FakeHttpClient([FakeResponse('', statusCode: status)]))
              .latest(),
          throwsA(
              isA<UpdateFailure>().having((e) => e.code, 'code', 'rateLimit')));
    }
    expect(
        GitHubUpdateClient(
                createClient: () =>
                    FakeHttpClient([FakeResponse('x' * (1024 * 1024 + 1))]))
            .latest(),
        throwsA(isA<UpdateFailure>()));
  });
  test('blocks non-HTTPS and third-party redirects', () async {
    for (final location in [
      'http://github.com/path',
      'https://evil.test/path'
    ]) {
      final http = FakeHttpClient([
        FakeResponse('', statusCode: 302, headers: {'location': location})
      ]);
      expect(GitHubUpdateClient(createClient: () => http).latest(),
          throwsA(isA<UpdateFailure>()));
    }
  });
  test('download enforces exact byte size and cleans partial files', () async {
    final temp = await Directory.systemTemp.createTemp('ltv-update-test');
    addTearDown(() => temp.delete(recursive: true));
    final target = '${temp.path}/update.apk';
    final download = UpdateDownloader(
        createClient: () => FakeHttpClient([
              FakeResponse.chunks([
                [1, 2],
                [3]
              ])
            ]));
    final progress = <double>[];
    await download.download(nextRelease().asset!, target, progress.add);
    expect(await File(target).readAsBytes(), [1, 2, 3]);
    expect(progress.last, 1);
    final truncated = UpdateDownloader(
        createClient: () => FakeHttpClient([
              FakeResponse.chunks([
                [1, 2]
              ])
            ]));
    await expectLater(truncated.download(nextRelease().asset!, target, (_) {}),
        throwsA(isA<UpdateFailure>()));
    await Future<void>.delayed(Duration.zero);
    expect(await File('$target.part').exists(), isFalse);
  });
  test('cancelled downloads remove temporary data', () async {
    final temp = await Directory.systemTemp.createTemp('ltv-update-cancel');
    addTearDown(() => temp.delete(recursive: true));
    final target = '${temp.path}/update.apk';
    final download = UpdateDownloader(
        createClient: () => FakeHttpClient([
              FakeResponse.chunks([
                [1],
                [2],
                [3]
              ])
            ]));
    await expectLater(
        download.download(
            nextRelease().asset!, target, (_) => download.cancel()),
        throwsA(
            isA<UpdateFailure>().having((e) => e.code, 'code', 'cancelled')));
    expect(await File('$target.part').exists(), isFalse);
    expect(await File(target).exists(), isFalse);
  });
}
