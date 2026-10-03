import 'package:flutter_test/flutter_test.dart';
import 'package:flauncher/updates/update_release.dart';
import 'update_fixture.dart';

void main() {
  test('build numbers take precedence over tags; never downgrade', () {
    final update = nextRelease();
    expect(update.newerThan(8112, '2099.1.1'), isTrue);
    expect(update.newerThan(8113, '2020.1.1'), isFalse);
    expect(update.newerThan(9000, '2020.1.1'), isFalse);
  });
  test('legacy tags compare numerically including date zero padding', () {
    expect(compareVersionNames('2026.10.2', '2026.09.30'), greaterThan(0));
    expect(compareVersionNames('2026.10.01', '2026.10.1'), 0);
    expect(compareVersionNames('dev', '2026.10.1'), 0);
    expect(UpdateRelease.fromJson(source()).asset, isNull);
  });
  test('rejects drafts and prereleases', () {
    for (final flag in ['draft', 'prerelease']) {
      expect(() => UpdateRelease.fromJson(source()..[flag] = true),
          throwsFormatException);
    }
  });
  test('rejects untrusted URLs, package, build, size and hash mismatches', () {
    for (final bad in [
      manifest()..['packageName'] = 'other.app',
      manifest()..['versionCode'] = 0,
      manifest()..['versionName'] = '2027.1.1',
      manifest()..['schemaVersion'] = 2,
      manifest()..['assets'][0]['size'] = 4,
      manifest()..['assets'][0]['sha256'] = 'invalid',
    ]) {
      expect(
          () => UpdateRelease.fromJson(source(), bad), throwsFormatException);
    }
    for (final url in [
      'http://github.com/$updateRepository/releases/download/v2026.10.02/$universalApk',
      'https://evil.test/$universalApk',
      'https://github.com/other/repo/releases/download/v2026.10.02/$universalApk',
      'https://github.com/$updateRepository/releases/download/v2020.1.1/$universalApk'
    ]) {
      final bad = source();
      bad['assets'][0]['browser_download_url'] = url;
      expect(
          () => UpdateRelease.fromJson(bad, manifest()), throwsFormatException);
    }
  });
  test('TV changelog omits release boilerplate and simplifies markdown', () {
    expect(
        readableChangelog(
            "Donation\n## 🚀 What's New\n### Fixes\n- **Home** [details](https://example.test)\n## 📦 Downloads\nAPK table"),
        "🚀 What's New\nFixes\n- Home details");
  });
}
