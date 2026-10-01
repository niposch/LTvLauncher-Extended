import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flauncher/gradients.dart';
import 'package:flauncher/widgets/wallpaper_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final gradient in [
    FLauncherGradients.greatWhale,
    FLauncherGradients.oldHat
  ]) {
    testWidgets(
        '${gradient.name} keeps the original background and scrim pixels',
        (tester) async {
      Future<Uint8List> capture({required bool cached}) async {
        final background = DecoratedBox(
            decoration: BoxDecoration(gradient: gradient.gradient));
        final key = UniqueKey();
        await tester.pumpWidget(MaterialApp(
            home: Center(
                child: RepaintBoundary(
          key: key,
          child: SizedBox(
              width: 320,
              height: 180,
              child: cached
                  ? WallpaperBackground(child: background)
                  : Stack(fit: StackFit.expand, children: [
                      background,
                      DecoratedBox(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.45)
                        ],
                      ))),
                    ])),
        ))));
        final boundary =
            tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
        return (await tester.runAsync(() async {
          final image = await boundary.toImage();
          final bytes =
              await image.toByteData(format: ui.ImageByteFormat.rawRgba);
          image.dispose();
          return bytes!.buffer.asUint8List();
        }))!;
      }

      final original = await capture(cached: false);
      final cached = await capture(cached: true);
      expect(cached, orderedEquals(original));
    });
  }
}
