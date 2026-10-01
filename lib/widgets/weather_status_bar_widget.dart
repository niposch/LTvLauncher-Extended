import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/models/weather_data.dart';
import 'package:flauncher/l10n/app_localizations.dart';
import 'package:flauncher/providers/weather_service.dart';
import 'package:flauncher/widgets/settings/settings_panel.dart';
import 'package:flauncher/widgets/settings/weather_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeatherStatusBarWidget extends StatefulWidget {
  static const double pillHeight = 48;

  final FocusNode? focusNode;

  const WeatherStatusBarWidget({Key? key, this.focusNode}) : super(key: key);

  @override
  State<WeatherStatusBarWidget> createState() => _WeatherStatusBarWidgetState();
}

class _WeatherStatusBarWidgetState extends State<WeatherStatusBarWidget> {
  bool _focused = false;

  void _openSettings() => showDialog<void>(
        context: context,
        builder: (_) =>
            const SettingsPanel(initialRoute: WeatherSettingsPage.routeName),
      );
  @override
  Widget build(BuildContext context) {
    return Selector<SettingsService, (bool, bool, bool, bool, bool)>(
      selector: (_, settings) => (
        settings.showWeatherInStatusBar,
        settings.showWeatherWarnings,
        settings.useFahrenheit,
        settings.showWeatherHighLow,
        settings.showWeatherRainChance,
      ),
      builder: (context, settingsTuple, _) {
        final (
          showWeather,
          showWarnings,
          useFahrenheit,
          showHighLow,
          showRainChance
        ) = settingsTuple;
        if (!showWeather) return const SizedBox.shrink();

        return Consumer<WeatherService>(
          builder: (context, weatherService, _) {
            final weather = weatherService.weatherData;

            final bool isWarning =
                showWarnings && (weather?.hasWarning ?? false);
            final icon = weather?.getConditionIcon() ?? Icons.cloud_outlined;
            final tempText =
                weather?.formatTemperature(useFahrenheit: useFahrenheit) ??
                    (weatherService.configured
                        ? weatherService.initialized
                            ? AppLocalizations.of(context)!.weatherUnavailable
                            : AppLocalizations.of(context)!.weatherUpdating
                        : AppLocalizations.of(context)!.configureWeather);
            final details = <String>[];
            if (showHighLow && weather != null) {
              final range = <String>[
                if (weather.dailyHigh != null)
                  '↑${WeatherData.formatDegrees(weather.dailyHigh, useFahrenheit: useFahrenheit)}',
                if (weather.dailyLow != null)
                  '↓${WeatherData.formatDegrees(weather.dailyLow, useFahrenheit: useFahrenheit)}',
              ];
              if (range.isNotEmpty) details.add(range.join(' '));
            }
            if (showRainChance && weather?.todayPrecipProbability != null) {
              details.add(AppLocalizations.of(context)!
                  .weatherRainChance(weather!.todayPrecipProbability!));
            }

            String displayText;
            if (isWarning && weather?.warningText != null) {
              displayText = "$tempText • ${weather!.warningText}";
            } else {
              displayText = tempText;
            }

            final theme = Theme.of(context);

            return Actions(
              actions: <Type, Action<Intent>>{
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) => _openSettings(),
                ),
                ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
                  onInvoke: (_) => _openSettings(),
                ),
              },
              child: Focus(
                focusNode: widget.focusNode,
                onFocusChange: (hasFocus) =>
                    setState(() => _focused = hasFocus),
                child: InkWell(
                  canRequestFocus: false,
                  onTap: () => _openSettings(),
                  borderRadius: BorderRadius.circular(14),
                  focusColor: Colors.transparent,
                  child: AnimatedContainer(
                    key: const Key('statusbar_weather_pill'),
                    height: WeatherStatusBarWidget.pillHeight,
                    duration: const Duration(milliseconds: 150),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _focused
                            ? theme.colorScheme.primary
                            : Colors.white.withOpacity(0.12),
                        width: 1,
                      ),
                      boxShadow: _focused
                          ? const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.32),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            size: 20,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 2),
                                  blurRadius: 4)
                            ],
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.1,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black54,
                                        offset: Offset(0, 2),
                                        blurRadius: 4)
                                  ],
                                ),
                              ),
                              if (details.isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(
                                  details.join(' · '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      height: 1.2,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70),
                                ),
                              ],
                            ],
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
