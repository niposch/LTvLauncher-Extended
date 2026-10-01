// Documentation-only entry point. It uses the actual launcher widgets with
// fictional content, in-memory settings/database, and original Canvas artwork.
// Build with: flutter build apk --debug -t tool/screenshots/main.dart
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flauncher/database.dart';
import 'package:flauncher/flauncher_app.dart';
import 'package:flauncher/flauncher_channel.dart';
import 'package:flauncher/fork/jellyfin_service.dart';
import 'package:flauncher/fork/seerr_service.dart';
import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/providers/backup_service.dart';
import 'package:flauncher/providers/brightness_service.dart';
import 'package:flauncher/providers/launcher_state.dart';
import 'package:flauncher/providers/network_service.dart';
import 'package:flauncher/providers/notifications_service.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/providers/tv_inputs_service.dart';
import 'package:flauncher/providers/wallpaper_service.dart';
import 'package:flauncher/providers/watch_next_service.dart';
import 'package:flauncher/providers/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsApp.debugAllowBannerOverride = false;
  // Give the rasterizer a frame before generating in-memory illustration PNGs.
  runApp(const MaterialApp(
      home: Scaffold(
    backgroundColor: Colors.black,
    body: Center(child: CircularProgressIndicator()),
  )));
  await WidgetsBinding.instance.endOfFrame;
  await initializeDateFormatting();
  // This documentation fixture intentionally substitutes in-memory preferences.
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({
    'show_continue_watching': true,
    'continue_watching_show_percentage': true,
    'show_weather_in_status_bar': true,
    'show_weather_warnings': false,
    'show_weather_high_low': true,
    'show_weather_rain_chance': true,
    'show_notifications_widget_in_status_bar': false,
    'show_inputs_widget_in_status_bar': false,
    'show_wifi_widget_in_status_bar': false,
    'show_network_indicator_in_status_bar': false,
    'app_key_click_enabled': false,
    'weather_location': jsonEncode({
      'name': 'Berlin',
      'latitude': 52.52,
      'longitude': 13.405,
    }),
  });
  final preferences = await SharedPreferences.getInstance();
  final settings = SettingsService(preferences);
  final database = FLauncherDatabase.inMemory();
  final channel = await ScreenshotChannel.create();
  final apps = AppsService(channel, database);
  while (!apps.initialized) {
    await Future<void>.delayed(const Duration(milliseconds: 16));
  }
  for (final category
      in apps.categories.where((c) => c.applications.isEmpty).toList()) {
    await apps.deleteSection(
        apps.launcherSections.indexWhere((s) => s.id == category.id));
  }
  runApp(MultiProvider(providers: [
    Provider(create: (_) => BackupService(database, preferences)),
    ChangeNotifierProvider<SettingsService>.value(value: settings),
    ChangeNotifierProvider<AppsService>.value(value: apps),
    ChangeNotifierProvider(create: (_) => LauncherState()),
    ChangeNotifierProvider(create: (_) => NetworkService(channel)),
    ChangeNotifierProvider(create: (_) => WallpaperService(channel, settings)),
    ChangeNotifierProvider(create: (_) => BrightnessService(preferences)),
    ChangeNotifierProvider(create: (_) => TvInputsService(channel)),
    ChangeNotifierProvider(create: (_) => NotificationsService(channel)),
    ChangeNotifierProvider(create: (_) => WatchNextService(channel)),
    ChangeNotifierProvider(
        create: (_) => WeatherService(channel,
            settings: settings,
            fetchWeather: (_) async => ScreenshotChannel.weather)),
    ChangeNotifierProvider(create: (_) => JellyfinService(channel)),
    ChangeNotifierProvider(create: (_) => SeerrService(channel)),
  ], child: const FLauncherApp()));
}

class ScreenshotChannel extends FLauncherChannel {
  static const names = ['Cinema', 'Music', 'Gallery', 'Files', 'Settings'];
  static const icons = [
    Icons.play_arrow_rounded,
    Icons.music_note_rounded,
    Icons.photo_outlined,
    Icons.folder_outlined,
    Icons.settings_outlined
  ];
  static const colors = [
    Color(0xFF7C4DFF),
    Color(0xFF087F8C),
    Color(0xFFBD632F),
    Color(0xFF3B65AB),
    Color(0xFF5C6170)
  ];
  static const titles = [
    'Beyond the Horizon',
    'Quiet Hours',
    'Among the Pines',
    'Open Skies'
  ];
  static const descriptions = [
    'A journey through imagined mountain landscapes.',
    'Watch the stars rise over a peaceful lake.',
    'Follow a winding trail through an evergreen forest.',
    'Find a new perspective above the clouds.'
  ];
  static final weather = jsonEncode({
    'location': 'Berlin',
    'currentTemp': 18,
    'currentConditionCode': 800,
    'todayMinTemp': 12,
    'todayMaxTemp': 21,
    'forecasts': [
      {'conditionCode': 800, 'precipProbability': 10}
    ],
  });
  final List<Uint8List> posters;
  final List<Uint8List> banners;
  final List<Uint8List> appIcons;
  ScreenshotChannel(this.posters, this.banners, this.appIcons);

  static Future<ScreenshotChannel> create() async => ScreenshotChannel(
        await Future.wait(List.generate(4, _landscape)),
        await Future.wait(List.generate(5, (i) => _appArtwork(i, false))),
        await Future.wait(List.generate(5, (i) => _appArtwork(i, true))),
      );

  @override
  Future<List<Map<dynamic, dynamic>>> getApplications() async => [
        for (var i = 0; i < names.length; i++)
          {
            'packageName': 'demo.${names[i].toLowerCase()}',
            'name': names[i],
            'version': '1.0',
            'sideloaded': false,
          }
      ];
  int _index(String package) =>
      names.indexWhere((n) => package == 'demo.${n.toLowerCase()}');
  @override
  Future<Uint8List> getApplicationBanner(String package) async =>
      banners[math.max(0, _index(package))];
  @override
  Future<Uint8List> getApplicationIcon(String package) async =>
      appIcons[math.max(0, _index(package))];
  @override
  Future<List<Map<dynamic, dynamic>>> getWatchNextPrograms() async => [
        for (var i = 0; i < titles.length; i++)
          {
            'id': i + 1,
            'packageName': 'demo.cinema',
            'title': titles[i],
            'description': descriptions[i],
            'watchNextType': 0,
            'lastEngagementTime': 1000000000000 - i,
            'playbackPosition': [13, 48, 85, 22][i],
            'duration': 100,
            'intentUri': 'demo:$i',
            'posterArtUri': 'demo:$i',
          }
      ];
  @override
  Future<Uint8List?> getWatchNextPoster(String uri) async =>
      posters[int.parse(uri.split(':').last)];
  @override
  Future<bool> checkWatchNextPermission() async => true;
  @override
  Future<Map<String, dynamic>> getActiveNetworkInformation() async => {
        'internetAccess': true,
        'networkType': 2,
        'wirelessSignalLevel': 4,
      };
  @override
  Future<bool> checkUsageStatsPermission() async => false;
  @override
  Future<bool> checkNotificationListenerPermission() async => false;
  @override
  Future<bool> checkOverlayPermission() async => false;
  @override
  Future<List<Map<dynamic, dynamic>>> getTvInputs() async => [];
  @override
  Future<bool> isBreezyWeatherInstalled() async => false;
  @override
  Future<String?> getLatestWeatherData() async => weather;
  @override
  void addAppsChangedListener(void Function(Map<String, dynamic>) listener) {}
  @override
  void addNetworkChangedListener(
      void Function(Map<String, dynamic>) listener) {}
  @override
  StreamSubscription<dynamic> addWeatherChangedListener(
          void Function(dynamic) listener) =>
      const Stream.empty().listen(listener);
  @override
  StreamSubscription<dynamic> addWatchNextChangedListener(
          void Function(dynamic) listener) =>
      const Stream.empty().listen(listener);
  @override
  Future<void> playClickSound() async {}
}

Future<Uint8List> _png(
    ui.PictureRecorder recorder, int width, int height) async {
  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
  image.dispose();
  picture.dispose();
  return bytes;
}

Future<Uint8List> _appArtwork(int index, bool square) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final size = Size(square ? 256 : 640, square ? 256 : 360);
  canvas.drawRect(
      Offset.zero & size, Paint()..color = ScreenshotChannel.colors[index]);
  final icon = ScreenshotChannel.icons[index];
  final painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
              fontFamily: icon.fontFamily,
              fontSize: square ? 128 : 92,
              color: Colors.white)))
    ..layout();
  painter.paint(
      canvas,
      Offset((size.width - painter.width) / 2,
          square ? (size.height - painter.height) / 2 : 82));
  if (!square) {
    final label = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: ScreenshotChannel.names[index],
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Colors.white)))
      ..layout();
    label.paint(canvas, Offset((size.width - label.width) / 2, 218));
  }
  return _png(recorder, size.width.toInt(), size.height.toInt());
}

Future<Uint8List> _landscape(int index) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  const size = Size(1280, 720);
  final palettes = [
    [const Color(0xFF89CDF0), const Color(0xFF354B91)],
    [const Color(0xFF162C65), const Color(0xFF8057A2)],
    [const Color(0xFFEFBD84), const Color(0xFF436966)],
    [const Color(0xFF648EB9), const Color(0xFFE1BD9D)],
  ];
  canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: palettes[index])
            .createShader(Offset.zero & size));
  canvas.drawCircle(Offset(index == 1 ? 920 : 965, 145), index == 1 ? 62 : 80,
      Paint()..color = const Color(0xFFFFE7B1));
  if (index == 1) {
    final random = math.Random(42);
    for (var i = 0; i < 65; i++) {
      canvas.drawCircle(
          Offset(random.nextDouble() * 1280, random.nextDouble() * 300),
          1 + random.nextDouble() * 2,
          Paint()..color = Colors.white70);
    }
  }
  for (var layer = 0; layer < 3; layer++) {
    final path = Path()..moveTo(0, 430 + layer * 90.0);
    for (var x = 0; x <= 1280; x += 128) {
      path.lineTo(
          x.toDouble(),
          300 +
              layer * 100.0 +
              math.sin(x / 160 + index + layer) * (70 - layer * 10));
    }
    path
      ..lineTo(1280, 720)
      ..lineTo(0, 720)
      ..close();
    canvas.drawPath(
        path,
        Paint()
          ..color = Color.lerp(
              palettes[index][1], const Color(0xFF142F3B), layer / 2)!);
  }
  if (index == 2) {
    for (var x = 40; x < 1280; x += 145) {
      final tree = Path()
        ..moveTo(x.toDouble(), 470)
        ..lineTo(x + 60, 270)
        ..lineTo(x + 120, 470)
        ..close();
      canvas.drawPath(tree, Paint()..color = const Color(0xFF214E44));
    }
  }
  return _png(recorder, 1280, 720);
}
