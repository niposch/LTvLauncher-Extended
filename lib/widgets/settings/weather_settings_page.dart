/*
 * FLauncher
 * Copyright (C) 2024 Oscar Rojas
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flauncher/providers/weather_service.dart';
import 'package:flauncher/fork/fork_config.dart';
import 'package:flauncher/widgets/settings/weather_location_dialog.dart';
import 'package:flauncher/widgets/rounded_switch_list_tile.dart';
import 'package:flauncher/widgets/settings/focusable_settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flauncher/l10n/app_localizations.dart';

import '../../providers/settings_service.dart';

class WeatherSettingsPage extends StatelessWidget {
  static const String routeName = "weather_settings";
  const WeatherSettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final settingsService = context.watch<SettingsService>();
    return Column(children: [
      Text(localizations.weatherSettings,
          style: Theme.of(context).textTheme.titleLarge),
      const Divider(),
      Expanded(
          child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          RoundedSwitchListTile(
            autofocus: !settingsService.showWeatherInStatusBar,
            value: settingsService.showWeatherInStatusBar,
            onChanged: (value) =>
                settingsService.setShowWeatherInStatusBar(value),
            title: Text(localizations.weather),
            secondary: Icon(Icons.wb_sunny_outlined),
          ),
          if (settingsService.showWeatherInStatusBar) ...[
            Consumer<WeatherService>(
                builder: (context, weather, _) => FocusableSettingsTile(
                      autofocus: true,
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(
                          '${localizations.weatherLocation}: ${settingsService.weatherLocation?.name ?? weather.weatherData?.location ?? localizations.weatherNoLocation}'),
                      onPressed: () async {
                        final location = await showDialog<WeatherLocation>(
                          context: context,
                          builder: (_) => const WeatherLocationDialog(),
                        );
                        if (location != null)
                          await settingsService.setWeatherLocation(location);
                      },
                    )),
            Consumer<WeatherService>(
                builder: (context, weather, _) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      child: Text(
                        settingsService.weatherLocation != null ||
                                weather.usesOpenMeteo
                            ? 'Open-Meteo'
                            : weather.isBreezyInstalled
                                ? 'Breezy Weather'
                                : localizations.weatherAutomatic,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )),
            if (settingsService.weatherLocation != null)
              FocusableSettingsTile(
                leading: const Icon(Icons.restore),
                title: Text(localizations.weatherAutomatic),
                onPressed: () => settingsService.setWeatherLocation(null),
              ),
            RoundedSwitchListTile(
              value: settingsService.showWeatherHighLow,
              onChanged: settingsService.setShowWeatherHighLow,
              title: Text(localizations.showWeatherHighLow),
              secondary: const Icon(Icons.thermostat_outlined),
            ),
            RoundedSwitchListTile(
              value: settingsService.showWeatherRainChance,
              onChanged: settingsService.setShowWeatherRainChance,
              title: Text(localizations.showWeatherRainChance),
              secondary: const Icon(Icons.umbrella_outlined),
            ),
            RoundedSwitchListTile(
              value: settingsService.showWeatherWarnings,
              onChanged: (value) =>
                  settingsService.setShowWeatherWarnings(value),
              title: Text(localizations.showWeatherWarnings),
              secondary: Icon(Icons.thunderstorm_outlined),
            ),
            FocusableSettingsTile(
              leading: const Icon(Icons.thermostat_outlined),
              title: Text(
                "${localizations.temperatureUnit}: ${settingsService.useFahrenheit ? localizations.fahrenheit : localizations.celsius}",
              ),
              onPressed: () {
                final next = settingsService.useFahrenheit
                    ? TEMPERATURE_UNIT_CELSIUS
                    : TEMPERATURE_UNIT_FAHRENHEIT;
                settingsService.setTemperatureUnit(next);
              },
            ),
            Consumer<WeatherService>(
              builder: (context, weatherService, _) {
                if (!weatherService.hasWeather) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 20, color: Colors.white70),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              localizations.weatherSetupHint,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ],
      )),
    ]);
  }
}
