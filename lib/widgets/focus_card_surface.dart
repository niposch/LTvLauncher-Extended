import 'package:flutter/material.dart';

/// Keeps scaling, elevation, clipping, and dimming on the same animation clock.
class FocusCardSurface extends StatelessWidget {
  final bool focused;
  final double focusedScale;
  final double focusedElevation;
  final double inactiveDimOpacity;
  final bool animate;
  final BorderRadius borderRadius;
  final Color? color;
  final Widget child;

  const FocusCardSurface({
    super.key,
    required this.focused,
    required this.focusedScale,
    required this.focusedElevation,
    required this.borderRadius,
    required this.child,
    this.inactiveDimOpacity = 0,
    this.animate = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: focused ? 1 : 0, end: focused ? 1 : 0),
        duration: animate ? const Duration(milliseconds: 200) : Duration.zero,
        curve: Curves.easeOutCubic,
        child: child,
        builder: (context, focus, child) => Transform.scale(
          scale: 1 + (focusedScale - 1) * focus,
          child: Material(
            color: color,
            borderRadius: borderRadius,
            // Composite artwork and shading before rounding the edge; clipping
            // each overlapping paint separately leaves a bright corner fringe.
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: focusedElevation * focus,
            shadowColor: Colors.black,
            surfaceTintColor: Colors.transparent,
            // The shared tween already animates elevation. A second Material
            // animation would leave the shadow behind the shrinking image.
            animationDuration: Duration.zero,
            child: Stack(
              fit: StackFit.expand,
              children: [
                child!,
                if (inactiveDimOpacity > 0)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ColoredBox(
                          color: Colors.black
                              .withOpacity(inactiveDimOpacity * (1 - focus))),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
