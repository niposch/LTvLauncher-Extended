import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Visible above drawers and dialogs, without receiving focus or pointer input.
class DebugBuildBadge extends StatelessWidget {
  final Widget child;

  const DebugBuildBadge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return child;
    return Stack(fit: StackFit.expand, children: [
      child,
      Positioned(
        right: 16,
        bottom: 16,
        child: IgnorePointer(
            child: SafeArea(
                child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text('DEBUG · LTv Extended',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none)),
          ),
        ))),
      ),
    ]);
  }
}
