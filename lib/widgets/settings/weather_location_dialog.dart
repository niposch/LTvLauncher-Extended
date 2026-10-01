import 'package:flauncher/fork/fork_config.dart';
import 'package:flauncher/fork/weather_location_search.dart';
import 'package:flauncher/l10n/app_localizations.dart';
import 'package:flauncher/widgets/settings/focusable_settings_tile.dart';
import 'package:flutter/material.dart';

class WeatherLocationDialog extends StatefulWidget {
  final Future<List<WeatherLocation>> Function(String query, String language)?
      search;

  const WeatherLocationDialog({super.key, this.search});

  @override
  State<WeatherLocationDialog> createState() => _WeatherLocationDialogState();
}

class _WeatherLocationDialogState extends State<WeatherLocationDialog> {
  final _query = TextEditingController();
  final _resultsFocus = FocusNode();
  List<WeatherLocation> _results = const [];
  bool _loading = false;
  bool _searched = false;
  bool _failed = false;
  int _request = 0;

  Future<void> _search() async {
    final request = ++_request;
    final language = Localizations.localeOf(context).languageCode;
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _failed = false;
      _results = const [];
    });
    try {
      final results = await (widget.search?.call(_query.text, language) ??
          searchWeatherLocations(_query.text, language: language));
      if (!mounted || request != _request) return;
      setState(() {
        _results = results;
        _loading = false;
        _searched = true;
      });
      if (results.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && request == _request) _resultsFocus.requestFocus();
        });
      }
    } catch (_) {
      if (!mounted || request != _request) return;
      setState(() {
        _failed = true;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _query.dispose();
    _resultsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.weatherLocation),
      content: SizedBox(
        width: 520,
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.weatherLocationHint,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: TextField(
                controller: _query,
                autofocus: true,
                decoration: InputDecoration(labelText: l10n.searchWeatherCity),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
              )),
              const SizedBox(width: 12),
              TextButton(onPressed: _search, child: Text(l10n.weatherSearch)),
            ]),
            const SizedBox(height: 12),
            if (_loading) const LinearProgressIndicator(),
            if (_failed) Text(l10n.weatherSearchFailed),
            if (_searched && !_loading && !_failed && _results.isEmpty)
              Text(l10n.weatherNoLocations),
            Expanded(
                child: Focus(
              focusNode: _resultsFocus,
              // Focus the first result after the keyboard closes.
              onFocusChange: (focused) {
                if (focused && _resultsFocus.hasPrimaryFocus)
                  _resultsFocus.nextFocus();
              },
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) => FocusableSettingsTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(_results[index].name),
                  onPressed: () => Navigator.of(context).pop(_results[index]),
                ),
              ),
            )),
            const Text('Open-Meteo · GeoNames',
                style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.dismiss))
      ],
    );
  }
}
