import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../updates/github_update_client.dart';
import '../updates/update_channel.dart';
import '../updates/update_release.dart';

class UpdateService extends ChangeNotifier with WidgetsBindingObserver {
  final SharedPreferences preferences;
  final GitHubUpdateClient client;
  final UpdateChannel channel;
  final UpdateDownloader downloader;
  final DateTime Function() now;
  late final Future<void> initialized;
  Timer? _timer;
  bool _disposed = false;
  bool checking = false, downloading = false, installing = false, ready = false;
  bool installerOpened = false, historyLoading = false;
  double progress = 0;
  String? error, historyError;
  InstalledUpdateInfo? installed;
  UpdateRelease? release;
  List<UpdateRelease> history = [];
  bool get automatic => preferences.getBool('updates.automatic') ?? true;
  DateTime? get lastChecked =>
      DateTime.tryParse(preferences.getString('updates.lastSuccess') ?? '');
  bool get available =>
      installed != null &&
      release != null &&
      release!.newerThan(installed!.versionCode, installed!.versionName);
  bool get busy => checking || downloading || installing;

  UpdateService(this.preferences,
      {GitHubUpdateClient? client,
      UpdateChannel? channel,
      UpdateDownloader? downloader,
      DateTime Function()? now,
      bool startAutomatically = true})
      : client = client ?? GitHubUpdateClient(),
        channel = channel ?? UpdateChannel(),
        downloader = downloader ?? UpdateDownloader(),
        now = now ?? DateTime.now {
    initialized = _initialize();
    if (startAutomatically) {
      WidgetsBinding.instance.addObserver(this);
      _timer = Timer.periodic(const Duration(hours: 1), (_) {
        if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed)
          check();
      });
      initialized.then((_) {
        if (!_disposed) check();
      });
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> _initialize() async {
    try {
      installed = await channel.info();
      final cached = preferences.getString('updates.cachedRelease');
      if (cached != null) {
        try {
          final decoded = jsonDecode(cached) as Map<String, dynamic>;
          release = UpdateRelease.fromJson(
              (decoded['source'] as Map).cast<String, dynamic>(),
              (decoded['manifest'] as Map?)?.cast<String, dynamic>());
        } catch (_) {
          await preferences.remove('updates.cachedRelease');
        }
      }
    } catch (_) {
      error = 'platform';
    }
    _notify();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      channel.info().then((info) {
        if (!_disposed) {
          installed = info;
          _notify();
          check();
        }
      }).catchError((Object _) {});
    }
  }

  Future<void> setAutomatic(bool enabled) async {
    await preferences.setBool('updates.automatic', enabled);
    _notify();
    if (enabled) await check();
  }

  Future<void> check({bool force = false}) async {
    await initialized;
    if (_disposed || busy || installed == null) return;
    final attempted =
        DateTime.tryParse(preferences.getString('updates.lastAttempt') ?? '');
    if (!force &&
        (!automatic ||
            (attempted != null &&
                !now().isBefore(attempted) &&
                now().difference(attempted) < const Duration(days: 1)))) return;
    checking = true;
    error = null;
    _notify();
    try {
      await preferences.setString(
          'updates.lastAttempt', now().toIso8601String());
      final latest = await client.latest();
      if (_disposed) return;
      release = latest;
      ready = false;
      installerOpened = false;
      if (latest != null) {
        await preferences.setString('updates.cachedRelease',
            jsonEncode({'source': latest.source, 'manifest': latest.manifest}));
      } else {
        await preferences.remove('updates.cachedRelease');
      }
      await preferences.setString(
          'updates.lastSuccess', now().toIso8601String());
    } catch (e) {
      error = _errorCode(e);
    } finally {
      checking = false;
      _notify();
    }
  }

  Future<void> loadHistory() async {
    if (_disposed || historyLoading) return;
    historyLoading = true;
    historyError = null;
    _notify();
    try {
      history = await client.history();
    } catch (e) {
      historyError = _errorCode(e);
    } finally {
      historyLoading = false;
      _notify();
    }
  }

  Future<void> downloadAndInstall() async {
    if (busy || !available || installed!.debug || release!.asset == null)
      return;
    downloading = true;
    progress = 0;
    error = null;
    installerOpened = false;
    _notify();
    final selected = release!;
    try {
      await downloader.download(selected.asset!, installed!.updatePath,
          (value) {
        progress = value;
        _notify();
      });
      if (_disposed) return;
      ready = true;
    } catch (e) {
      ready = false;
      error = _errorCode(e);
    } finally {
      downloading = false;
      _notify();
    }
    if (ready && !_disposed) await install();
  }

  void cancelDownload() => downloader.cancel();
  Future<void> allowInstalls() async {
    try {
      await channel.allowInstalls();
    } catch (e) {
      error = _errorCode(e);
      _notify();
    }
  }

  Future<void> install() async {
    if (busy || !ready || !available || installed!.debug) return;
    installing = true;
    error = null;
    _notify();
    try {
      final status =
          await channel.install(release!.asset!.sha256, release!.versionCode!);
      if (status == 'permissionRequired') {
        error = 'permission';
      } else {
        installerOpened = true;
      }
    } catch (e) {
      error = _errorCode(e);
    } finally {
      installing = false;
      _notify();
    }
  }

  String _errorCode(Object e) => e is UpdateFailure
      ? e.code
      : e is PlatformException
          ? e.code
          : e is FormatException || e is TypeError
              ? 'metadata'
              : 'network';

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    downloader.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
