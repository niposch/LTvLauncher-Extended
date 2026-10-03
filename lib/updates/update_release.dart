const updateRepository = 'niposch/LTvLauncher-Extended';
const releasePackage = 'com.niposch.ltvlauncher.extended';
const universalApk = 'LTv-Extended-universal-release.apk';
const maxUpdateBytes = 200 * 1024 * 1024;

bool trustedReleaseAsset(Uri uri) =>
    uri.scheme == 'https' &&
    uri.host == 'github.com' &&
    uri.userInfo.isEmpty &&
    uri.port == 443 &&
    uri.path.startsWith('/$updateRepository/releases/download/');

class UpdateAsset {
  final String name;
  final Uri url;
  final int size;
  final String sha256;
  const UpdateAsset(this.name, this.url, this.size, this.sha256);
}

class UpdateRelease {
  final String tag, name, notes;
  final DateTime? published;
  final Uri page;
  final int? versionCode;
  final String versionName;
  final UpdateAsset? asset;
  final Map<String, dynamic> source;
  final Map<String, dynamic>? manifest;

  UpdateRelease.fromJson(this.source, [this.manifest])
      : tag = source['tag_name'] as String,
        name = (source['name'] as String?) ?? source['tag_name'] as String,
        notes = (manifest?['changelog'] as String?) ??
            (source['body'] as String? ?? ''),
        published = DateTime.tryParse(source['published_at'] as String? ?? ''),
        page = Uri.parse(source['html_url'] as String),
        versionCode = manifest?['versionCode'] as int?,
        versionName = (manifest?['versionName'] as String?) ??
            (source['tag_name'] as String).replaceFirst(RegExp(r'^v'), ''),
        asset = _asset(source, manifest) {
    if (source['draft'] != false ||
        source['prerelease'] != false ||
        page.scheme != 'https' ||
        page.host != 'github.com' ||
        !page.path.startsWith('/$updateRepository/releases/')) {
      throw const FormatException('Unsupported release');
    }
    if (manifest != null &&
        (manifest!['schemaVersion'] != 1 ||
            manifest!['packageName'] != releasePackage ||
            versionCode == null ||
            versionCode! <= 0 ||
            versionName != tag.replaceFirst(RegExp(r'^v'), '') ||
            asset == null)) {
      throw const FormatException('Invalid update manifest');
    }
  }

  static UpdateAsset? _asset(
      Map<String, dynamic> release, Map<String, dynamic>? manifest) {
    if (manifest == null) return null;
    final assets = (release['assets'] as List).cast<Map<String, dynamic>>();
    final declared = (manifest['assets'] as List).cast<Map<String, dynamic>>();
    for (final item in assets.where((a) => a['name'] == universalApk)) {
      final uri = Uri.parse(item['browser_download_url'] as String);
      for (final entry in declared.where((a) => a['name'] == universalApk)) {
        final size = entry['size'] as int;
        final hash = entry['sha256'] as String;
        if (trustedReleaseAsset(uri) &&
            uri.pathSegments[uri.pathSegments.length - 2] ==
                release['tag_name'] &&
            uri.pathSegments.last == universalApk &&
            item['size'] == size &&
            size > 0 &&
            size <= maxUpdateBytes &&
            RegExp(r'^[a-f0-9]{64}$').hasMatch(hash)) {
          return UpdateAsset(universalApk, uri, size, hash);
        }
      }
    }
    return null;
  }

  bool newerThan(int installedCode, String installedName) => versionCode != null
      ? versionCode! > installedCode
      : compareVersionNames(versionName, installedName) > 0;
}

// Legacy releases have no manifest. Numeric tag comparison is only a notice;
// installation requires manifest build numbers and Android archive validation.
int compareVersionNames(String left, String right) {
  List<int>? parts(String s) => RegExp(r'^\d+(\.\d+){2}$').hasMatch(s)
      ? s.split('.').map(int.parse).toList()
      : null;
  final a = parts(left), b = parts(right);
  if (a == null || b == null) return 0;
  for (var i = 0; i < 3; i++) {
    final comparison = a[i].compareTo(b[i]);
    if (comparison != 0) return comparison;
  }
  return 0;
}

// Release bodies include donation/download sections. Keep the changes readable
// on TV without fetching images, executing HTML or making remote links focusable.
String readableChangelog(String markdown) {
  var text = markdown;
  final start = text.indexOf("## 🚀 What's New");
  if (start >= 0) text = text.substring(start);
  final end = text.indexOf('## 📦 Downloads');
  if (end >= 0) text = text.substring(0, end);
  return text
      .replaceAll(RegExp(r'^#{1,6}\s+', multiLine: true), '')
      .replaceAllMapped(RegExp(r'!?\[([^\]]+)\]\([^)]+\)'), (m) => m[1]!)
      .replaceAll('**', '')
      .replaceAll('`', '')
      .trim();
}
