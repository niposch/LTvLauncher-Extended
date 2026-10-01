import 'package:flauncher/fork/fork_config.dart';

/// City/region/country labels distinguish places with the same name.
List<WeatherLocation> parseWeatherLocations(Map<String, dynamic> json) {
  final results = json['results'] as List? ?? const [];
  return results
      .whereType<Map<String, dynamic>>()
      .map((result) {
        final parts = <String>[];
        for (final key in ['name', 'admin1', 'country']) {
          final value = result[key];
          if (value is String && value.isNotEmpty && !parts.contains(value))
            parts.add(value);
        }
        return WeatherLocation.fromJson({...result, 'name': parts.join(', ')});
      })
      .whereType<WeatherLocation>()
      .where((location) => location.name.isNotEmpty)
      .toList();
}

Future<List<WeatherLocation>> searchWeatherLocations(String query,
    {String language = 'en'}) async {
  if (query.trim().length < 2) return const [];
  final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
    'name': query.trim(),
    'count': '10',
    'language': language,
    'format': 'json',
  });
  return parseWeatherLocations(await getJson(uri) as Map<String, dynamic>);
}
