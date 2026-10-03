# LTv Extended development

## Orientation

Read `README.md` and the relevant guides in `docs/` before changing behavior.
This is a Flutter Android TV launcher with Java platform integrations.
`lib/` contains UI, providers and platform channels; `android/app/src/main/java/com/leanbitlab/ltvL/`
is the active Android implementation. The older `me/efesser/flauncher/` Java sources
are legacy: check the Gradle namespace and manifest before choosing a file to edit.
`test/` contains Dart tests; `android/app/src/test/` contains native unit tests.

## Compatibility and implementation

- Preserve the release application ID, debug suffix, native class namespace,
  platform-channel names, preferences and database compatibility. Debug builds must
  use `com.niposch.ltvlauncher.extended.debug` and **LTv Extended (Debug)**, install
  alongside release, and retain their on-screen DEBUG badge plus small purple
  Material `bug_report` marks on the icon/banner. Never use the release identity for debug testing or
  replace release with a debug-signed APK. Release builds must contain none of
  these debug markers.
  Android application IDs and Java class names differ; build component names
  from both correctly.
- Keep TV navigation usable with D-pad, Select, Back and Home. Home should dismiss
  drawers/dialogs and reveal the launcher; ordinary resume should preserve navigation.
- Handle boot, standby wake and explicit Home as separate lifecycle events.
  Accessibility redirects must be bounded and must not interrupt resumed apps,
  playback, Android settings or unrelated windows. Release receivers, nodes,
  callbacks and subscriptions when their owner is destroyed.
- Keep update checks quiet and bounded; downloads and Android installation must be
  explicit user actions. Preserve update manifest schema, APK verification and debug
  isolation. Release tags must match version names, version codes must increase,
  and published APKs must retain their signing identity; see `docs/updating.md`.
- Query the selected Home role/preference when reporting the default launcher.
  Intent resolution can disagree with user selection on vendor TV firmware.
- Support the declared minimum Android SDK; guard newer APIs and retain both
  ARMv7 and ARM64 builds. Avoid expensive work on the UI thread.
- Reuse established Material icons where appropriate; preserve their source
  attribution and license when importing assets.
- Use the existing providers and channel architecture. Keep changes focused,
  preserve upstream attribution, and localize new user-facing settings in `lib/l10n/`.
- Keep credentials, signing material, device addresses, local paths, captured media
  and personal server configuration out of versioned files and logs.

## Build and validation

Use the Flutter/Java/Android SDK versions in `docs/extensions.md` and the release
workflow. Do not upgrade dependencies or toolchains as a side effect of a fix.
Use existing locally configured tools when available.

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
flutter test
cd android
./gradlew :app:testDebugUnitTest
cd ..
flutter build apk --debug --target-platform=android-arm,android-arm64
```

Windows database tests need an x64 `sqlite3.dll` on PATH. Generated mocks and
migration fixtures are ignored; regenerate them rather than editing them.
Add regression coverage for behavioral fixes, run relevant tests and analyze
changed Dart files, then build Android when native code changes. Broaden testing
when integration risk warrants it. Do not reformat unrelated files.

Document behavior, prerequisites and validation limits in the appropriate guide.
Distinguish automated tests, APK build checks and actual device observations;
do not report a hardware scenario as passed without exercising it. Device installation,
configuration changes and publishing must remain within the user's authorized scope.
Use release signing configuration when supplied; never commit private keys.
