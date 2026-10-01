import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/models/weather_data.dart';
import 'package:flauncher/l10n/app_localizations.dart';
import 'package:flauncher/providers/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeatherStatusBarWidget extends StatefulWidget {
  final FocusNode? focusNode;

  const WeatherStatusBarWidget({Key? key, this.focusNode}) : super(key: key);

  @override
  State<WeatherStatusBarWidget> createState() => _WeatherStatusBarWidgetState();
}

class _WeatherStatusBarWidgetState extends State<WeatherStatusBarWidget> {
  bool _focused = false;

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
            if (weather == null) return const SizedBox.shrink();

            final bool isWarning = showWarnings && weather.hasWarning;
            final icon = weather.getConditionIcon();
            final tempText =
                weather.formatTemperature(useFahrenheit: useFahrenheit);
            final details = <String>[];
            if (showHighLow) {
              final range = <String>[
                if (weather.dailyHigh != null)
                  '↑${WeatherData.formatDegrees(weather.dailyHigh, useFahrenheit: useFahrenheit)}',
                if (weather.dailyLow != null)
                  '↓${WeatherData.formatDegrees(weather.dailyLow, useFahrenheit: useFahrenheit)}',
              ];
              if (range.isNotEmpty) details.add(range.join(' '));
            }
            if (showRainChance && weather.todayPrecipProbability != null) {
              details.add(AppLocalizations.of(context)!
                  .weatherRainChance(weather.todayPrecipProbability!));
            }

            String displayText;
            if (isWarning && weather.warningText != null) {
              displayText = "$tempText • ${weather.warningText}";
            } else {
              displayText = tempText;
            }

            final theme = Theme.of(context);

            return Actions(
              actions: <Type, Action<Intent>>{
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) => weatherService.openBreezyWeather(),
                ),
                ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
                  onInvoke: (_) => weatherService.openBreezyWeather(),
                ),
              },
              child: Focus(
                focusNode: widget.focusNode,
                onFocusChange: (hasFocus) =>
                    setState(() => _focused = hasFocus),
                child: InkWell(
                  onTap: () => weatherService.openBreezyWeather(),
                  borderRadius: BorderRadius.circular(14),
                  focusColor: Colors.transparent,
                  child: AnimatedContainer(
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
                              if (details.isNotEmpty)
                                Text(
                                  details.join(' · '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white70),
                                ),
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
