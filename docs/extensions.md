# Extension setup

The extensions come from [hamish henare's posters branch](https://github.com/hamishakl/LtvLauncher/tree/posters); see [attribution](../ATTRIBUTION.md).

## Installation and app identity

The release application ID is `com.niposch.ltvlauncher.extended`; debug builds append `.debug`. Android gives each installation its own database, preferences, poster cache, external files directory, and permissions. Existing upstream settings are not automatically imported. Enable notification access, accessibility, or the default home app separately for Extended if desired.

The native Java namespace remains `com.leanbitlab.ltvL`, so launch a release build with:

```sh
adb install path/to/app-release.apk
adb shell am start -n com.niposch.ltvlauncher.extended/com.leanbitlab.ltvL.MainActivity
```

For debug APKs, use `com.niposch.ltvlauncher.extended.debug` in the command and configuration directory below.

## Weather and media configuration

Launch the app once to create its external files directory, then create a local `fork_config.json` with your own values:

```json
{
  "weather": {
    "name": "Berlin",
    "latitude": 52.52,
    "longitude": 13.405
  },
  "jellyfin": {
    "url": "http://your-jellyfin-server:8096",
    "apiKey": "YOUR_JELLYFIN_API_KEY",
    "userId": "YOUR_JELLYFIN_USER_ID"
  },
  "seerr": {
    "url": "https://your-seerr-server",
    "apiKey": "YOUR_SEERR_API_KEY"
  }
}
```

Omit `jellyfin` or `seerr` to disable that integration. Configuration is read once per app process and kept out of settings backups. Keep your local file and API keys out of Git.

```sh
adb push fork_config.json /sdcard/Android/data/com.niposch.ltvlauncher.extended/files/fork_config.json
adb shell am force-stop com.niposch.ltvlauncher.extended
adb shell am start -n com.niposch.ltvlauncher.extended/com.leanbitlab.ltvL.MainActivity
```

Enable Continue Watching in launcher settings to show the media rows. Jellyfin supplies Next Up and Recently Added; selecting an item opens `org.jellyfin.androidtv`. Seerr supplies For You recommendations; selecting an item opens the Seerr TV app (`seerrtv://` deep links). Each app must be installed to open its items.

When Breezy Weather is absent and no broadcast weather data is available, weather is fetched from Open-Meteo at most every 30 minutes after a successful fetch. The inherited default location is Auckland; configure `weather` to use your location. Jellyfin refreshes every 10 minutes, and Seerr every 30 minutes, with additional refreshes on resume.

Remote artwork is downloaded and downscaled to at most 640 pixels wide, cached privately on disk, and pruned after 30 days without access. The app requests Internet access and permits HTTP for local media servers. It contacts Open-Meteo, configured media servers, and artwork hosts such as TMDB; it does not add analytics.

## Local build

Use Flutter 3.24.5, Java 21, and Android SDK 35:

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test test/providers/watch_next_service_test.dart
flutter build apk --debug --target-platform=android-arm,android-arm64
```

Release builds use the existing keystore environment variables or `android/local.properties` signing configuration. For device testing with a local debug key, an unsigned release APK can be signed locally with Android build-tools `apksigner`; keep private signing material out of the repository.
