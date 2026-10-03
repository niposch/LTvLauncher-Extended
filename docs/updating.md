# In-app updates

**Updates** is the second entry in Settings, directly below **System settings**. Open **Settings → Updates** to check for a release, read **What’s new**, or browse the ten most recent stable releases. Release notes support D-pad Up/Down scrolling and OK to close.

Automatic checks are enabled by default and can be switched off. They contact the public GitHub Releases API at most once every 24 hours while the launcher is running, including after resume. The last attempt is persisted, so restarting the app does not bypass the limit. Failed checks also back off for 24 hours; **Check for updates** always permits an immediate retry. A cached update notice remains available offline. There are no startup prompts, background downloads, analytics, accounts or embedded access tokens.

When a newer release is available, the Settings entry gains an **Update available** indicator. Choose **Download update** to download the universal ARMv7/ARM64 APK into private cache, with progress and cancellation. The app verifies the declared size, SHA-256 hash, Android package, signing identity and strictly greater Android version code before opening Android’s installer. Android checks device compatibility and asks the user to confirm installation. On Android 8+, enable **Allow updates from this app** if prompted, return to the launcher, and choose **Install update**. Cancelled or failed installations can be retried; the download button can fetch a fresh copy. No broad file/storage permissions or silent installation are used.

Debug builds keep their separate `.debug` identity, name and visual markers. They can check releases and read changelogs but both the Flutter UI and native bridge block installing production APKs. The page tells users to open **LTv Extended** (without the Debug suffix) to download and install release updates; its download action appears only when a newer release is available. Updates from another signing source (for example a separately signed distribution) are rejected; users must continue using that source’s updater. Drafts and prereleases are excluded.

## Release contract

The update source is `niposch/LTvLauncher-Extended` on GitHub. `lib/updates/` contains release parsing, bounded HTTPS fetching, download handling and the native channel. `UpdateService` owns check cadence, cache and UI state. The native `AppUpdateManager` and `UpdatePackagePolicy` validate the archive and hand it to Android through a narrowly scoped FileProvider.

Every new update release must:

1. Increase the Android build number in `pubspec.yaml` (`versionName+versionCode`). Keep the release application ID and existing signing key.
2. Use a tag exactly matching `v` plus the version name, for example `v2026.10.02` for `2026.10.02+8113`. Do not replace previously published release assets or reuse build numbers.
3. Write user-facing changes in `fastlane/metadata/android/en-US/changelogs/<versionCode>.txt`. Release generation falls back to commit subjects if that file is absent.
4. Run `.github/workflows/release.yml` through the matching pushed tag or workflow dispatch. The workflow requires all four signing secrets: `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`. Keep their values outside source control and logs.

The workflow builds signed universal and split APKs, then `.github/scripts/generate_update_manifest.py` produces `update.json` with schema version 1, package name, version name/code, changelog, and each APK’s filename, byte size and SHA-256 hash. It uploads this file alongside the APKs into a draft, then publishes only after every asset is uploaded successfully so checks never see a partially assembled update. The app chooses the universal asset to support both existing ARM architectures. The manifest and APK URLs must belong to this repository’s release download path; HTTPS redirects are restricted to GitHub’s API/release hosts. Transfers and metadata have size limits and network timeouts.

Existing releases without `update.json` still show their GitHub changelog and can produce a notice through numeric version-name comparison. They need manual installation. Existing users must install an updater-enabled release once; their older app cannot discover this new feature itself. Subsequent releases are offered in-app without a separate update server.

The [GitHub Releases API](https://docs.github.com/en/rest/releases/releases), Android’s [install-source permission](https://developer.android.com/reference/android/content/pm/PackageManager#canRequestPackageInstalls()), and [FileProvider](https://developer.android.com/reference/androidx/core/content/FileProvider) define the external integration.

## Verification — 2026-10-03

- Full Flutter suite: 320 tests passed, with two existing skips. The 22 new tests cover metadata/source validation, numeric/build comparison, release history transport, oversized responses, redirect restrictions, byte counts, cancellation cleanup, persisted cadence/cache, offline failures, concurrent checks, manual checks, debug isolation, install permission retry, quiet notices and D-pad changelog scrolling/closing.
- Native suite: 14 tests passed, including seven new archive-policy cases for identity, debug builds, version mismatch/downgrade, unsupported SDK, signer mismatch, verified key rotation, multiple signers and unsigned archives.
- Three Python release-manifest tests passed; manifest generation was also checked against all three actual built APKs. The live public API returned the existing stable release and changelog successfully; the existing 2026.10.01 release had no update manifest at the time of this check.
- Separate debug and signed release universal ARMv7/ARM64 APKs built successfully. The release signing certificate matches the existing release key. The debug APK was installed alongside release; the original release Home role and accessibility service remain selected.
- On-device checks opened Updates through D-pad navigation and displayed the actual GitHub changelog with the debug badge. The production download/install sequence is covered by automated tests and compilation, but a complete installation of a newer published release has not been exercised. These implementation checks preceded release publication; signing secrets were unchanged.

English and German update UI strings are translated; other locales use the generated English fallback until contributed translations are available.

## Release preparation

**2026.10.03** (Android version code **8113**) introduced the in-app updater. The follow-up release is **2026.10.04** (Android version code **8114**), moving Updates to the second Settings entry and clarifying debug installation guidance. Its changelog is `fastlane/metadata/android/en-US/changelogs/8114.txt`. Android CI tests run after Flutter builds the APKs, which generates the ignored Gradle wrapper on a clean checkout.
