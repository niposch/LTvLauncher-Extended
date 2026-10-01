# Repeatable documentation captures

This entry point runs the actual launcher widgets with an in-memory database and
preferences, fictional program metadata, original procedural landscape artwork,
and generic app tiles. It does not read installed apps or the device's Watch Next
provider. Weather values are fixtures, with no forecast network requests.

The source is maintained on `codex/documentation-screenshots`, separately from the
release branch. To retake screenshots of a newer version, merge `master` into this
branch and resolve any provider API changes before building.

```sh
flutter pub get
flutter build apk --debug --target-platform=android-arm -t tool/screenshots/main.dart
adb install -r build/app/outputs/flutter-apk/app-debug.apk
adb shell am start -W -n com.niposch.ltvlauncher.extended.debug/com.leanbitlab.ltvL.MainActivity
```

Use a device without an existing Extended debug installation. This capture build
uses `com.niposch.ltvlauncher.extended.debug`; the release installation and its
settings remain intact. Wait until all artwork and fonts have loaded, then capture
the home, settings drawer, and weather settings using `adb shell screencap -p` and
`adb pull`. Capture the actual screen; do not composite poster replacements over
screenshots from real accounts.

Save the new images as `docs/images/home.png`, `settings.png`, and `weather.png` on
`master`, and copy them into the Fastlane `tvScreenshots` directory. Verify every
image before committing. After capturing, uninstall this documentation debug app
and return to the user's release launcher.

The procedural landscape illustrations and fictional metadata created for this
fixture are dedicated to the public domain under
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/). The launcher source
retains its GPL license. Flutter Material icons retain their upstream license.
The fixture was created with Codex assistance, credited in its commit.
