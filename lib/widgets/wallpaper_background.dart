import 'package:flutter/widgets.dart';

/// Composites a static wallpaper and its scrim into the surrounding layer's cache.
class WallpaperBackground extends StatelessWidget {
  final Widget child;

  const WallpaperBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) => CustomPaint(
        // The launcher's RepaintBoundary retains the display list. The cache
        // hint also lets the engine reuse its full-screen shader/image result.
        isComplex: true,
        foregroundPainter: const _WallpaperScrimPainter(),
        child: child,
      );
}

class _WallpaperScrimPainter extends CustomPainter {
  const _WallpaperScrimPainter();

  static const _scrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x59000000), Color(0x26000000), Color(0x73000000)],
  );

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..shader = _scrim.createShader(rect));
  }

  @override
  bool shouldRepaint(_WallpaperScrimPainter oldDelegate) => false;
}
