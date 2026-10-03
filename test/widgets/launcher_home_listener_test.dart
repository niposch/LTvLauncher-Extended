import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/providers/launcher_state.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/l10n/app_localizations.dart';
import 'package:flauncher/widgets/launcher_home_listener.dart';
import 'package:flauncher/widgets/settings/accessibility_page.dart';
import 'package:flauncher/widgets/settings/settings_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../mocks.mocks.dart';

const homeChannel = 'me.efesser.flauncher/event_home';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    messenger.setMockMethodCallHandler(
        const MethodChannel(homeChannel), (_) async => null);
    messenger.setMockMethodCallHandler(
        const MethodChannel('me.efesser.flauncher/method'), (_) async => false);
  });
  tearDown(() {
    messenger.setMockMethodCallHandler(const MethodChannel(homeChannel), null);
    messenger.setMockMethodCallHandler(
        const MethodChannel('me.efesser.flauncher/method'), null);
  });

  Future<void> home(WidgetTester tester) async {
    await messenger.handlePlatformMessage(homeChannel,
        const StandardMethodCodec().encodeSuccessEnvelope(true), (_) {});
    await tester.pumpAndSettle();
  }

  Future<LauncherState> pumpLauncher(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final state = LauncherState();
    final apps = MockAppsService();
    final settings = MockSettingsService();
    when(apps.isDefaultLauncher()).thenAnswer((_) async => true);
    when(settings.startOnBoot).thenReturn(false);
    when(settings.appHighlightAnimationEnabled).thenReturn(false);
    when(settings.accentColorHex).thenReturn('7C4DFF');
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<LauncherState>.value(value: state),
        ChangeNotifierProvider<AppsService>.value(value: apps),
        ChangeNotifierProvider<SettingsService>.value(value: settings),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: LauncherHomeListener(
            child: Scaffold(
                body: Builder(
                    builder: (context) => TextButton(
                          onPressed: () => showDialog<void>(
                              context: context,
                              builder: (_) => const SettingsPanel(
                                  initialRoute: AccessibilityPage.routeName)),
                          child: const Text('Open settings'),
                        )))),
      ),
    ));
    await tester.pumpAndSettle();
    return state;
  }

  testWidgets(
      'Home closes settings even with a nested submenu and modal dialog',
      (tester) async {
    await pumpLauncher(tester);
    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPanel), findsOneWidget);
    final nested = tester.state<NavigatorState>(find.descendant(
        of: find.byType(SettingsPanel), matching: find.byType(Navigator)));
    nested.push(MaterialPageRoute<void>(
        builder: (context) => TextButton(
              onPressed: () => showDialog<void>(
                  context: context,
                  useRootNavigator: true,
                  builder: (_) =>
                      const AlertDialog(content: Text('Nested modal'))),
              child: const Text('Submenu'),
            )));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submenu'));
    await tester.pumpAndSettle();
    expect(find.text('Nested modal'), findsOneWidget);
    await home(tester);
    expect(find.byType(SettingsPanel), findsNothing);
    expect(find.text('Nested modal'), findsNothing);
    expect(find.text('Open settings'), findsOneWidget);
    await home(tester);
    expect(find.text('Open settings'), findsOneWidget);
  });

  testWidgets('Home restores the launcher from its clock view', (tester) async {
    final state = await pumpLauncher(tester);
    state.toggleLauncherVisibility();
    expect(state.launcherVisible, isFalse);
    await home(tester);
    expect(state.launcherVisible, isTrue);
  });

  testWidgets('resuming preserves an open settings drawer', (tester) async {
    await pumpLauncher(tester);
    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPanel), findsOneWidget);
  });
}
