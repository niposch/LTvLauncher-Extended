# Extension setup

The extensions come from [hamish henare's posters branch](https://github.com/hamishakl/LtvLauncher/tree/posters); see [attribution](../ATTRIBUTION.md).

## Installation and app identity

The visible app name is **LTv Extended**, including the TV banner, launcher icon, default-home picker, accessibility service, and screensaver. APK files use the prefix `LTv-Extended-`; the package ID remains unchanged so existing Extended installations retain their settings and data.

The release application ID is `com.niposch.ltvlauncher.extended`; debug builds append `.debug`. Android gives each installation its own database, preferences, poster cache, external files directory, and permissions. Existing upstream settings are not automatically imported. Enable notification access, accessibility, or the default home app separately for Extended if desired.

The native Java namespace remains `com.leanbitlab.ltvL`, so launch a release build with:

```sh
adb install path/to/app-release.apk
adb shell am start -n com.niposch.ltvlauncher.extended/com.leanbitlab.ltvL.MainActivity
```

For debug APKs, use `com.niposch.ltvlauncher.extended.debug` in the command and configuration directory below.

## Weather options

Open **Settings → Interface → Status bar**, enable **Weather**, then select **Weather location**. Search for a city or postal code and choose the matching region and country with the remote. This uses Open-Meteo for the selected city and refreshes immediately, even if Breezy Weather is installed. The selected location is saved in launcher settings and included in backups.

**Show today's high and low** and **Show today's rain / snow chance** are separate optional switches, off by default. The compact second line shows `↑` for the daily high, `↓` for the daily low, and `Precip.` for today's maximum precipitation probability (rain or snow). Temperatures follow the Celsius/Fahrenheit setting. Missing values are omitted; a warning about a later day does not replace today's probability.

**Use Breezy Weather / configured default** removes the city override. Weather then comes from Breezy broadcasts, or Open-Meteo when Breezy is absent. The legacy `weather` entry in `fork_config.json` remains the Open-Meteo fallback, with Auckland as the inherited default. The settings page displays the active city and source.

City search uses the [Open-Meteo Geocoding API](https://open-meteo.com/en/docs/geocoding-api), whose location data comes from GeoNames. Forecasts use [Open-Meteo](https://open-meteo.com/); no API key or device location permission is needed.

## Media and legacy weather configuration

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

Open-Meteo weather refreshes at most every 30 minutes after a successful fetch, with an immediate fetch when the selected city changes. Jellyfin refreshes every 10 minutes, and Seerr every 30 minutes, with additional refreshes on resume.

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

## Branding assets

`assets/icon.png` and `assets/banner.png` are the master artwork. After updating them, regenerate all Android icon densities, the 320×180 TV banners, and the metadata icon:

```sh
dart run flutter_launcher_icons
dart run tool/export_brand_assets.dart
```

Translations in `lib/l10n/*.arb` provide the app's visible name in settings and default-launcher prompts. Run `flutter gen-l10n` after editing them. Upstream names remain in credits and historical release notes; internal Dart/native identifiers and platform channels remain stable for compatibility.
