import 'dart:async';

import 'package:flauncher/flauncher_channel.dart';
import 'package:flauncher/providers/launcher_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Handles HOME independently of resume: returning from Android settings must
/// leave the drawer open, whereas HOME dismisses every route above the launcher.
class LauncherHomeListener extends StatefulWidget {
  final Widget child;

  const LauncherHomeListener({super.key, required this.child});

  @override
  State<LauncherHomeListener> createState() => _LauncherHomeListenerState();
}

class _LauncherHomeListenerState extends State<LauncherHomeListener> {
  StreamSubscription<void>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = FLauncherChannel().homeRequests.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true)
            .popUntil((route) => route.isFirst);
        context.read<LauncherState>().returnHome();
      });
      WidgetsBinding.instance.scheduleFrame();
    }, onError: (_) {
      // The Android channel is unavailable on other platforms.
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
