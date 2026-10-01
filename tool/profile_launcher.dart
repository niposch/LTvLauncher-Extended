// Optional entry point for measuring on-device frames. Production uses lib/main.dart.
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show InkWell;
import 'package:provider/provider.dart';
import 'package:flauncher/flauncher.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/providers/wallpaper_service.dart';
import 'package:flauncher/gradients.dart';
import 'package:flauncher/widgets/app_card.dart';
import 'package:flauncher/widgets/continue_watching_row.dart';

import 'package:flauncher/main.dart' as launcher;

Future<void> main() async {
  await launcher.main();
  installFrameProfiler();
}

void installFrameProfiler() {
  registerExtension('ext.ltv.focus', (method, parameters) async {
    final candidates = <Element>[];
    void visit(Element element) {
      if (parameters['row'] == 'posters'
          ? element.widget is WatchNextCard
          : element.widget is AppCard) {
        candidates.add(element);
      }
      element.visitChildren(visit);
    }

    final root = WidgetsBinding.instance.rootElement;
    if (root != null) visit(root);
    final index = int.tryParse(parameters['index'] ?? '') ?? 0;
    if (index < 0 || index >= candidates.length)
      return ServiceExtensionResponse.result(
          jsonEncode({'error': 'No card at index'}));
    void focus(Element element) {
      final widget = element.widget;
      if (widget is InkWell) widget.focusNode?.requestFocus();
      element.visitChildren(focus);
    }

    focus(candidates[index]);
    return ServiceExtensionResponse.result(
        jsonEncode({'row': parameters['row'], 'index': index}));
  });
  registerExtension('ext.ltv.settings', (method, parameters) async {
    SettingsService? settings;
    WallpaperService? wallpaper;
    void visit(Element element) {
      if (element.widget is FLauncher) {
        settings = element.read<SettingsService>();
        wallpaper = element.read<WallpaperService>();
      }
      element.visitChildren(visit);
    }

    final root = WidgetsBinding.instance.rootElement;
    if (root != null) visit(root);
    final service = settings;
    if (service == null)
      return ServiceExtensionResponse.result(
          jsonEncode({'error': 'Launcher not mounted'}));
    if (parameters.containsKey('highlight'))
      await service
          .setAppHighlightAnimationEnabled(parameters['highlight'] == 'true');
    if (parameters.containsKey('transition'))
      await service.setAppSelectorTransitionAnimationEnabled(
          parameters['transition'] == 'true');
    if (parameters.containsKey('continueWatching'))
      await service
          .setShowContinueWatching(parameters['continueWatching'] == 'true');
    if (parameters.containsKey('theme'))
      await service.setThemes(parameters['theme']!);
    if (parameters.containsKey('gradient')) {
      final gradient = FLauncherGradients.all.firstWhere((g) =>
          g.uuid == parameters['gradient'] || g.name == parameters['gradient']);
      await wallpaper!.setGradient(gradient);
    }
    return ServiceExtensionResponse.result(jsonEncode({
      'highlight': service.appHighlightAnimationEnabled,
      'transition': service.appSelectorTransitionAnimationEnabled,
      'continueWatching': service.showContinueWatching,
      'theme': service.themes,
      'gradient': wallpaper?.gradient.name,
    }));
  });
  final frames = <FrameTiming>[];
  var recording = false;
  WidgetsBinding.instance.addTimingsCallback((batch) {
    if (recording) frames.addAll(batch);
  });
  registerExtension('ext.ltv.frames', (method, parameters) async {
    if (parameters['action'] == 'start') {
      frames.clear();
      recording = true;
      return ServiceExtensionResponse.result(jsonEncode({'recording': true}));
    }
    recording = false;
    final budget =
        double.tryParse(parameters['budgetMs'] ?? '') ?? 1000 / 59.94;
    Map<String, dynamic> stats(List<double> values) {
      values.sort();
      double percentile(double p) =>
          values.isEmpty ? 0 : values[(p * (values.length - 1)).round()];
      return {
        'p50Ms': percentile(0.5),
        'p95Ms': percentile(0.95),
        'p99Ms': percentile(0.99),
        'maxMs': values.isEmpty ? 0 : values.last,
        'overBudget': values.where((v) => v > budget).length,
      };
    }

    final builds =
        frames.map((f) => f.buildDuration.inMicroseconds / 1000).toList();
    final rasters =
        frames.map((f) => f.rasterDuration.inMicroseconds / 1000).toList();
    final stages =
        List.generate(frames.length, (i) => math.max(builds[i], rasters[i]));
    return ServiceExtensionResponse.result(jsonEncode({
      'frames': frames.length,
      'budgetMs': budget,
      'build': stats(builds),
      'raster': stats(rasters),
      'slowestStage': stats(stages),
    }));
  });
}
