import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flauncher/l10n/app_localizations.dart';
import 'package:flauncher/providers/update_service.dart';
import 'package:flauncher/updates/update_release.dart';
import 'package:flauncher/widgets/settings/updates_page.dart';
import '../../updates/update_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late UpdateService service;
  late FakeUpdateApi api;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    api = FakeUpdateApi();
    service = UpdateService(await SharedPreferences.getInstance(),
        client: api, channel: FakeUpdateChannel(), startAutomatically: false);
    await service.initialized;
  });
  tearDown(() => service.dispose());
  Future<void> pump(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ChangeNotifierProvider.value(
        value: service,
        child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: SizedBox(width: 350, child: child)))));
    await tester.pumpAndSettle();
  }

  testWidgets('automatic update appears quietly in Settings without a dialog',
      (tester) async {
    await pump(tester, const UpdateSettingsTile());
    await tester.runAsync(() => service.check());
    await tester.pumpAndSettle();
    expect(find.text('Update available'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });
  testWidgets(
      'manual check works when automatic checks are disabled; notes open',
      (tester) async {
    await tester.runAsync(() => service.setAutomatic(false));
    await pump(tester, const UpdatesPage());
    expect(api.calls, 0);
    await tester.runAsync(() async {
      await tester.tap(find.text('Check for updates'));
      await Future<void>.delayed(const Duration(milliseconds: 20));
    });
    await tester.pumpAndSettle();
    expect(api.calls, 1);
    expect(find.text('Update available: 2026.10.02'), findsOneWidget);
    await tester.ensureVisible(find.text('What’s new'));
    await tester.tap(find.text('What’s new'));
    await tester.pumpAndSettle();
    expect(find.text('- Fixed Home navigation'), findsOneWidget);
  });
  testWidgets('TV arrows scroll changelog and Select closes it',
      (tester) async {
    final release = UpdateRelease.fromJson(source()
      ..['body'] = List.generate(80, (i) => '- Change $i').join('\n'));
    await pump(
        tester,
        Builder(
            builder: (context) => TextButton(
                onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => ReleaseNotesDialog(release: release)),
                child: const Text('Notes'))));
    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
    expect(scroll.position.pixels, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(scroll.position.pixels, greaterThan(0));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(scroll.position.pixels, 0);
    expect(tester.takeException(), isNull);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(ReleaseNotesDialog), findsNothing);
  });
}
