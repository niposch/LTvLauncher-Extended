import 'dart:ui' as ui;

import 'package:flauncher/widgets/focus_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget card(bool focused, {bool animate = true}) => MaterialApp(
        home: Center(
          child: SizedBox(
            width: 240,
            height: 135,
            child: FocusCardSurface(
              focused: focused,
              focusedScale: 1.1,
              focusedElevation: 16,
              inactiveDimOpacity: 0.1,
              animate: animate,
              borderRadius: BorderRadius.circular(8),
              child: const ColoredBox(key: Key('artwork'), color: Colors.white),
            ),
          ),
        ),
      );

  void expectSynchronized(WidgetTester tester, {bool intermediate = false}) {
    final surface = find.byType(FocusCardSurface);
    final material = tester.widget<Material>(
        find.descendant(of: surface, matching: find.byType(Material)));
    final transform = tester.widget<Transform>(
        find.descendant(of: surface, matching: find.byType(Transform)));
    final focus = material.elevation / 16;
    expect(transform.transform.entry(0, 0), closeTo(1 + focus * 0.1, 0.0001));
    expect(material.animationDuration, Duration.zero);
    expect(material.clipBehavior, Clip.antiAliasWithSaveLayer);
    expect(material.surfaceTintColor, Colors.transparent);
    final shade = tester.widget<ColoredBox>(
        find.descendant(of: surface, matching: find.byType(ColoredBox)).last);
    expect(shade.color.opacity, closeTo((1 - focus) * 0.1, 1 / 255));
    if (intermediate) expect(focus, inExclusiveRange(0, 1));
  }

  testWidgets(
      'Shrink, shadow, and dimming stay synchronized, including focus reversal',
      (tester) async {
    await tester.pumpWidget(card(true));
    await tester.pumpWidget(card(false));
    await tester.pump(const Duration(milliseconds: 80));
    expectSynchronized(tester, intermediate: true);
    await tester.pumpWidget(card(true));
    await tester.pump(const Duration(milliseconds: 70));
    expectSynchronized(tester, intermediate: true);
    await tester.pumpAndSettle();
    expectSynchronized(tester);
  });

  testWidgets('Disabled transitions update all focus effects immediately',
      (tester) async {
    await tester.pumpWidget(card(true, animate: false));
    await tester.pumpWidget(card(false, animate: false));
    await tester.pump();
    expectSynchronized(tester);
    final surface = find.byType(FocusCardSurface);
    final material = tester.widget<Material>(
        find.descendant(of: surface, matching: find.byType(Material)));
    expect(material.elevation, 0);
  });

  testWidgets(
      'Poster shading reaches the rounded corners without a bright fringe',
      (tester) async {
    const captureKey = Key('corner-capture');
    await tester.pumpWidget(MaterialApp(
      home: Center(
        child: RepaintBoundary(
          key: captureKey,
          child: SizedBox(
            width: 240,
            height: 135,
            child: ColoredBox(
              color: Colors.black,
              child: FocusCardSurface(
                focused: false,
                focusedScale: 1.1,
                focusedElevation: 16,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: Stack(fit: StackFit.expand, children: [
                  const ColoredBox(color: Colors.white),
                  ColoredBox(color: Colors.black.withOpacity(0.9)),
                ]),
              ),
            ),
          ),
        ),
      ),
    ));
    final boundary =
        tester.renderObject<RenderRepaintBoundary>(find.byKey(captureKey));
    final pixels = await tester.runAsync(() async {
      final image = await boundary.toImage();
      final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      image.dispose();
      return bytes!;
    });
    // The shaded white poster is ~26/255 grey. At every rounded edge the
    // coverage may blend toward black, but must never expose brighter artwork.
    for (final left in [true, false]) {
      for (final top in [true, false]) {
        for (var x = 0; x < 12; x++) {
          for (var y = 0; y < 12; y++) {
            final px = left ? x : 239 - x;
            final py = top ? y : 134 - y;
            expect(pixels!.getUint8((py * 240 + px) * 4), lessThanOrEqualTo(28),
                reason: 'Unshaded fringe at ($px, $py)');
          }
        }
      }
    }
  });
}
