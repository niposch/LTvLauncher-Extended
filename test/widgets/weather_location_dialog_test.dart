import 'package:flauncher/fork/fork_config.dart';
import 'package:flauncher/fork/weather_location_search.dart';
import 'package:flauncher/l10n/app_localizations.dart';
import 'package:flauncher/widgets/settings/weather_location_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('geocoding labels distinguish cities and reject invalid coordinates',
      () {
    final locations = parseWeatherLocations({
      'results': [
        {
          'name': 'Berlin',
          'admin1': 'Berlin',
          'country': 'Germany',
          'latitude': 52.5,
          'longitude': 13.4
        },
        {
          'name': 'Berlin',
          'admin1': 'Connecticut',
          'country': 'United States',
          'latitude': 41.6,
          'longitude': -72.8
        },
        {'name': 'Bad', 'latitude': 200, 'longitude': 13},
      ]
    });
    expect(locations.map((l) => l.name),
        ['Berlin, Germany', 'Berlin, Connecticut, United States']);
    expect(parseWeatherLocations({}), isEmpty);
  });

  testWidgets('city search returns a remote-selectable result', (tester) async {
    WeatherLocation? selected;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
          builder: (context) => Scaffold(
                  body: TextButton(
                child: const Text('Choose'),
                onPressed: () async {
                  selected = await showDialog<WeatherLocation>(
                      context: context,
                      builder: (_) => WeatherLocationDialog(
                            search: (query, language) async {
                              expect(query, 'Berlin');
                              return [
                                const WeatherLocation(
                                    name: 'Berlin, Germany',
                                    latitude: 52.5,
                                    longitude: 13.4)
                              ];
                            },
                          ));
                },
              ))),
    ));
    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Berlin');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('Berlin, Germany'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.select);
    await tester.pumpAndSettle();
    expect(selected?.name, 'Berlin, Germany');
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed search can be retried', (tester) async {
    var attempts = 0;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: WeatherLocationDialog(search: (_, __) async {
        if (++attempts == 1) throw Exception('offline');
        return [];
      })),
    ));
    await tester.enterText(find.byType(TextField), 'Unknown');
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Check your connection'), findsOneWidget);
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No locations found'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
