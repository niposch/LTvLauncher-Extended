import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flauncher/l10n/app_localizations.dart';
import 'package:flauncher/providers/update_service.dart';
import 'package:flauncher/updates/update_release.dart';
import 'package:flauncher/widgets/rounded_switch_list_tile.dart';
import 'focusable_settings_tile.dart';

class UpdateSettingsTile extends StatelessWidget {
  const UpdateSettingsTile({super.key});
  @override
  Widget build(BuildContext context) {
    final service = context.watch<UpdateService?>();
    if (service == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return FocusableSettingsTile(
      leading: Icon(
          service.available ? Icons.system_update : Icons.system_update_alt),
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.updatesTitle, style: Theme.of(context).textTheme.bodyMedium),
        if (service.available)
          Text(l.updatesAvailable,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      ]),
      onPressed: () => Navigator.of(context).pushNamed(UpdatesPage.routeName),
    );
  }
}

String updateErrorText(AppLocalizations l, String code) => switch (code) {
      'rateLimit' => l.updatesRateLimit,
      'metadata' || 'source' => l.updatesMetadataError,
      'integrity' => l.updatesIntegrityError,
      'signature' || 'package' => l.updatesSignatureError,
      'version' => l.updatesVersionError,
      'sdk' => l.updatesSdkError,
      'permission' => l.updatesPermissionHint,
      'installer' || 'platform' => l.updatesInstallerError,
      'cancelled' => l.updatesCancelled,
      'debug' => l.updatesDebugHint,
      _ => l.updatesNetworkError,
    };

class UpdatesPage extends StatefulWidget {
  static const routeName = 'updates';
  const UpdatesPage({super.key});
  @override
  State<UpdatesPage> createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  @override
  void initState() {
    super.initState();
    // Opening the page can check when automatic checks are enabled and due.
    // The explicit button always works, including when checks are disabled.
    context.read<UpdateService>().check();
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<UpdateService>();
    final l = AppLocalizations.of(context)!;
    final installed = service.installed;
    final release = service.release;
    Widget paragraph(String text, {Color? color}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(text, style: TextStyle(color: color)),
        );
    return Column(children: [
      Text(l.updatesTitle, style: Theme.of(context).textTheme.titleLarge),
      const Divider(),
      Expanded(
          child: ListView(children: [
        if (installed != null)
          paragraph(l.updatesInstalled(
              '${installed.versionName} (${installed.versionCode})')),
        RoundedSwitchListTile(
          title: Text(l.updatesAutomatic),
          value: service.automatic,
          secondary: const Icon(Icons.update),
          onChanged: service.setAutomatic,
        ),
        paragraph(l.updatesAutomaticHint),
        FocusableSettingsTile(
          autofocus: true,
          leading: const Icon(Icons.refresh),
          title: Text(service.checking ? l.updatesChecking : l.updatesCheck),
          onPressed: service.busy ? null : () => service.check(force: true),
        ),
        if (service.lastChecked != null)
          paragraph(l.updatesLastChecked(MaterialLocalizations.of(context)
              .formatShortDate(service.lastChecked!.toLocal()))),
        if (service.error != null)
          paragraph(updateErrorText(l, service.error!), color: Colors.amber),
        if (release == null &&
            service.lastChecked != null &&
            !service.checking &&
            service.error == null)
          paragraph(l.updatesNoReleases),
        if (release != null) ...[
          const Divider(),
          paragraph(
              service.available
                  ? l.updatesNewVersion(release.versionName)
                  : l.updatesUpToDate,
              color: service.available
                  ? Theme.of(context).colorScheme.primary
                  : null),
          FocusableSettingsTile(
            leading: const Icon(Icons.article_outlined),
            title: Text(l.updatesChangelog),
            onPressed: () => _showNotes(context, release),
          ),
          if (installed?.debug == true) paragraph(l.updatesDebugHint),
          if (service.available && installed?.debug == false) ...[
            if (release.asset == null)
              paragraph(l.updatesLegacyHint)
            else ...[
              if (service.downloading) ...[
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: LinearProgressIndicator(value: service.progress)),
                paragraph(l.updatesDownloading(
                    (service.progress * 100).round().toString())),
                FocusableSettingsTile(
                    leading: const Icon(Icons.cancel_outlined),
                    title: Text(l.updatesCancel),
                    onPressed: service.cancelDownload),
              ] else if (service.installing)
                paragraph(l.updatesVerifying)
              else if (service.ready) ...[
                if (service.installerOpened)
                  paragraph(l.updatesInstallerOpened),
                if (installed?.canInstall == false) ...[
                  paragraph(l.updatesPermissionHint),
                  FocusableSettingsTile(
                      leading: const Icon(Icons.security),
                      title: Text(l.updatesAllowInstalls),
                      onPressed: service.allowInstalls),
                ],
                FocusableSettingsTile(
                    leading: const Icon(Icons.install_mobile),
                    title: Text(l.updatesInstall),
                    onPressed: () => service.install()),
                FocusableSettingsTile(
                    leading: const Icon(Icons.refresh),
                    title: Text(l.updatesDownload(
                        '${(release.asset!.size / (1024 * 1024)).toStringAsFixed(1)} MB')),
                    onPressed: service.downloadAndInstall),
              ] else
                FocusableSettingsTile(
                  leading: const Icon(Icons.download),
                  title: Text(l.updatesDownload(
                      '${(release.asset!.size / (1024 * 1024)).toStringAsFixed(1)} MB')),
                  onPressed: service.busy ? null : service.downloadAndInstall,
                ),
            ],
          ],
        ],
        const Divider(),
        FocusableSettingsTile(
            leading: const Icon(Icons.history),
            title: Text(
                service.historyLoading ? l.updatesChecking : l.updatesHistory),
            onPressed: service.historyLoading ? null : service.loadHistory),
        if (service.historyError != null)
          paragraph(updateErrorText(l, service.historyError!),
              color: Colors.amber),
        for (final entry in service.history)
          FocusableSettingsTile(
            title: Text(entry.name),
            leading: const Icon(Icons.article_outlined),
            onPressed: () => _showNotes(context, entry),
          ),
      ])),
    ]);
  }

  void _showNotes(BuildContext context, UpdateRelease release) =>
      showDialog<void>(
          context: context,
          builder: (_) => ReleaseNotesDialog(release: release));
}

class ReleaseNotesDialog extends StatefulWidget {
  final UpdateRelease release;
  const ReleaseNotesDialog({super.key, required this.release});
  @override
  State<ReleaseNotesDialog> createState() => _ReleaseNotesDialogState();
}

class _ReleaseNotesDialogState extends State<ReleaseNotesDialog> {
  final _scroll = ScrollController();
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final notes = readableChangelog(widget.release.notes);
    return Focus(
      onKeyEvent: (_, event) {
        if (event is KeyUpEvent || !_scroll.hasClients)
          return KeyEventResult.ignored;
        final direction = event.logicalKey == LogicalKeyboardKey.arrowDown
            ? 1
            : event.logicalKey == LogicalKeyboardKey.arrowUp
                ? -1
                : 0;
        if (direction == 0) return KeyEventResult.ignored;
        final next = (_scroll.offset + direction * 100)
            .clamp(0.0, _scroll.position.maxScrollExtent);
        _scroll.jumpTo(next);
        return KeyEventResult.handled;
      },
      child: AlertDialog(
        title: Text(widget.release.name),
        content: SizedBox(
            width: 680,
            height: MediaQuery.sizeOf(context).height * .55,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (widget.release.published != null)
                Text(MaterialLocalizations.of(context)
                    .formatShortDate(widget.release.published!.toLocal())),
              Text(l.updatesScrollHint,
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              Expanded(
                  child: Scrollbar(
                      controller: _scroll,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                          controller: _scroll,
                          child: Text(notes.isEmpty ? l.updatesNoNotes : notes,
                              style: Theme.of(context).textTheme.bodyLarge)))),
            ])),
        actions: [
          TextButton(
              autofocus: true,
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.updatesClose))
        ],
      ),
    );
  }
}
