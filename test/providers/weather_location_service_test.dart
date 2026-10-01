import 'dart:async';
import 'dart:convert';

import 'package:flauncher/fork/fork_config.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/providers/weather_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const berlin =
      WeatherLocation(name: 'Berlin', latitude: 52.52, longitude: 13.4);
  const munich =
      WeatherLocation(name: 'Munich', latitude: 48.1, longitude: 11.6);

  test('selected city overrides Breezy broadcasts; resetting restores Breezy',
      () async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsService(await SharedPreferences.getInstance());
    await settings.setWeatherLocation(berlin);
    final channel = MockFLauncherChannel();
    final broadcasts = StreamController<dynamic>.broadcast();
    when(channel.isBreezyWeatherInstalled()).thenAnswer((_) async => true);
    when(channel.getLatestWeatherData())
        .thenAnswer((_) async => '{"location":"Breezy city","currentTemp":5}');
    when(channel.addWeatherChangedListener(any)).thenAnswer(
        (call) => broadcasts.stream.listen(call.positionalArguments.first));
    var fetches = 0;
    final service = WeatherService(channel, settings: settings,
        fetchWeather: (location) async {
      fetches++;
      return jsonEncode({'location': location.name, 'currentTemp': 20});
    });
    addTearDown(service.dispose);
    addTearDown(broadcasts.close);
    await pumpEventQueue();
    expect(service.weatherData?.location, 'Berlin');
    expect(service.usesOpenMeteo, isTrue);
    broadcasts.add('{"location":"wrong city","currentTemp":1}');
    await settings.setShowWeatherHighLow(true);
    await pumpEventQueue();
    expect(service.weatherData?.location, 'Berlin');
    expect(fetches, 1);
    await settings.setWeatherLocation(null);
    await pumpEventQueue();
    expect(service.weatherData?.location, 'Breezy city');
    expect(service.usesOpenMeteo, isFalse);
  });

  test('changing city immediately refetches and discards the old city response',
      () async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsService(await SharedPreferences.getInstance());
    await settings.setWeatherLocation(berlin);
    final channel = MockFLauncherChannel();
    when(channel.isBreezyWeatherInstalled()).thenAnswer((_) async => false);
    final broadcasts = StreamController<dynamic>.broadcast();
    when(channel.addWeatherChangedListener(any)).thenAnswer(
        (call) => broadcasts.stream.listen(call.positionalArguments.first));
    final requests = <String, Completer<String>>{};
    final service =
        WeatherService(channel, settings: settings, fetchWeather: (location) {
      return (requests[location.name] = Completer<String>()).future;
    });
    addTearDown(service.dispose);
    addTearDown(broadcasts.close);
    await pumpEventQueue();
    await settings.setWeatherLocation(munich);
    await pumpEventQueue();
    requests['Munich']!.complete('{"location":"Munich","currentTemp":25}');
    await pumpEventQueue();
    requests['Berlin']!.complete('{"location":"Berlin","currentTemp":2}');
    await pumpEventQueue();
    expect(service.weatherData?.location, 'Munich');
    expect(service.weatherData?.currentTemp, 25);
  });
}
