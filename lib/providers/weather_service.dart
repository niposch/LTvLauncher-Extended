import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'package:flauncher/flauncher_channel.dart';
import 'package:flauncher/fork/fork_config.dart';
import 'package:flauncher/fork/open_meteo.dart';
import 'package:flauncher/models/weather_data.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flutter/widgets.dart';

class WeatherService extends ChangeNotifier with WidgetsBindingObserver {
  final FLauncherChannel _channel;
  final SettingsService? _settings;
  final Future<String> Function(WeatherLocation) _fetchWeather;
  final Future<WeatherLocation?> Function() _loadFallbackLocation;
  bool _configured = false;
  String? _locationKey;
  int _locationRevision = 0;
  bool _disposed = false;
  bool _usesOpenMeteo = false;
  StreamSubscription<dynamic>? _subscription;
  Timer? _refreshTimer;
  DateTime? _lastResumeCheck;
  String? _lastJson;
  DateTime? _lastOpenMeteoFetch;

  WeatherData? _weatherData;
  bool _isBreezyInstalled = false;
  bool _initialized = false;

  bool get _isTest => Platform.environment.containsKey('FLUTTER_TEST');

  WeatherService(
    this._channel, {
    SettingsService? settings,
    Future<String> Function(WeatherLocation)? fetchWeather,
    Future<WeatherLocation?> Function()? loadFallbackLocation,
  })  : _settings = settings,
        _fetchWeather = fetchWeather ?? fetchOpenMeteoWeatherJson,
        _loadFallbackLocation = loadFallbackLocation ??
            (() async => (await ForkConfig.load()).weather) {
    _locationKey = _selectedLocationKey;
    _settings?.addListener(_onSettingsChanged);
    if (!_isTest) {
      WidgetsBinding.instance.addObserver(this);
    }
    _init();
  }

  WeatherData? get weatherData => _weatherData;
  bool get isBreezyInstalled => _isBreezyInstalled;
  bool get initialized => _initialized;
  bool get hasWeather => _weatherData != null;
  bool get usesOpenMeteo => _usesOpenMeteo;
  bool get configured => _settings?.weatherLocation != null || _configured;

  String? get _selectedLocationKey =>
      _settings?.weatherLocation?.toJson().toString();

  void _onSettingsChanged() {
    final key = _selectedLocationKey;
    if (key == _locationKey) return;
    _locationKey = key;
    _locationRevision++;
    _lastOpenMeteoFetch = null;
    _lastJson = null;
    _configured = false;
    // Do not label the old city's weather as the newly selected city.
    _weatherData = null;
    notifyListeners();
    _fetchLatest();
  }

  Future<void> _init() async {
    try {
      await _fetchLatest();

      _subscription = _channel.addWeatherChangedListener((event) {
        if (_settings?.weatherLocation == null &&
            event is String &&
            event.isNotEmpty) {
          _usesOpenMeteo = false;
          _processWeatherJson(event);
        }
      });
      if (_disposed) {
        await _subscription?.cancel();
        return;
      }
      _startPeriodicTimer();
    } catch (e, stack) {
      developer.log("Error initializing WeatherService",
          error: e, stackTrace: stack);
    } finally {
      _initialized = true;
      if (!_disposed) notifyListeners();
    }
  }

  void _startPeriodicTimer() {
    _refreshTimer?.cancel();
    // 15-minute fallback timer in case a broadcast was missed while paused
    _refreshTimer =
        Timer.periodic(const Duration(minutes: 15), (_) => _fetchLatest());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _refreshTimer?.cancel();
      _refreshTimer = null;
    } else if (state == AppLifecycleState.resumed) {
      _checkWeatherOnResume();
      _startPeriodicTimer();
    }
  }

  Future<void> _checkWeatherOnResume() async {
    final now = DateTime.now();
    if (_lastResumeCheck != null &&
        now.difference(_lastResumeCheck!).inSeconds < 60) {
      return;
    }
    _lastResumeCheck = now;
    await _fetchLatest();
  }

  Future<void> _fetchLatest() async {
    final revision = _locationRevision;
    try {
      _isBreezyInstalled = await _channel.isBreezyWeatherInstalled();
      if (_disposed || revision != _locationRevision) return;
      if (_settings?.weatherLocation != null) {
        await _fetchOpenMeteo(revision);
        return;
      }
      final latestJson = await _channel.getLatestWeatherData();
      if (_disposed || revision != _locationRevision) return;
      if (latestJson != null && latestJson.isNotEmpty) {
        _configured = true;
        _usesOpenMeteo = false;
        _processWeatherJson(latestJson);
      } else if (!_isBreezyInstalled) {
        await _fetchOpenMeteo(revision);
      }
    } catch (e, stack) {
      developer.log("Failed to fetch latest weather data",
          error: e, stackTrace: stack);
    }
  }

  // Fork: without Breezy Weather, fetch directly from Open-Meteo (at most every 30 min).
  Future<void> _fetchOpenMeteo(int revision) async {
    final now = DateTime.now();
    if (_lastOpenMeteoFetch != null &&
        now.difference(_lastOpenMeteoFetch!).inMinutes < 30 &&
        _weatherData != null) {
      return;
    }
    try {
      final location =
          _settings?.weatherLocation ?? await _loadFallbackLocation();
      if (_disposed || revision != _locationRevision) return;
      _configured = location != null;
      if (location == null) return;
      final json = await _fetchWeather(location);
      if (_disposed || revision != _locationRevision) return;
      _usesOpenMeteo = true;
      _lastOpenMeteoFetch = now;
      _processWeatherJson(json);
    } catch (e, stack) {
      developer.log("Open-Meteo fetch failed", error: e, stackTrace: stack);
    }
  }

  void _processWeatherJson(String jsonString) {
    if (_disposed) return;
    if (jsonString == _lastJson && _weatherData != null) {
      return;
    }
    try {
      _weatherData = WeatherData.fromJsonString(jsonString);
      _configured = true;
      _lastJson = jsonString;
      notifyListeners();
    } catch (e, stack) {
      developer.log("Failed to parse weather JSON",
          error: e, stackTrace: stack);
    }
  }

  Future<bool> openBreezyWeather() async {
    try {
      return await _channel.openBreezyWeather();
    } catch (e) {
      return false;
    }
  }

  Future<void> refresh() async {
    _lastOpenMeteoFetch = null;
    await _fetchLatest();
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _settings?.removeListener(_onSettingsChanged);
    if (!_isTest) {
      WidgetsBinding.instance.removeObserver(this);
    }
    _refreshTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
