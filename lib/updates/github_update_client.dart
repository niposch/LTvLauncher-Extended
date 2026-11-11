import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'update_release.dart';

class UpdateFailure implements Exception {
  final String code;
  const UpdateFailure(this.code);
}

bool _trustedRedirect(Uri uri) =>
    uri.scheme == 'https' &&
    uri.userInfo.isEmpty &&
    uri.port == 443 &&
    const {
      'api.github.com',
      'github.com',
      'release-assets.githubusercontent.com',
      'objects.githubusercontent.com'
    }.contains(uri.host);

Future<HttpClientResponse> openUpdateUrl(HttpClient client, Uri url) async {
  for (var redirects = 0; redirects < 6; redirects++) {
    if (!_trustedRedirect(url)) throw const UpdateFailure('source');
    final request =
        await client.getUrl(url).timeout(const Duration(seconds: 15));
    request.followRedirects = false;
    request.headers.set(HttpHeaders.userAgentHeader, 'LTv-Extended-Updater');
    request.headers
        .set(HttpHeaders.acceptHeader, 'application/vnd.github+json');
    request.headers.set('X-GitHub-Api-Version', '2022-11-28');
    final response = await request.close().timeout(const Duration(seconds: 20));
    if ([301, 302, 303, 307, 308].contains(response.statusCode)) {
      final location = response.headers.value(HttpHeaders.locationHeader);
      if (location == null) throw const UpdateFailure('source');
      url = url.resolve(location);
      await response.drain<void>().timeout(const Duration(seconds: 20));
      continue;
    }
    return response;
  }
  throw const UpdateFailure('source');
}

class GitHubUpdateClient {
  final HttpClient Function() createClient;
  GitHubUpdateClient({HttpClient Function()? createClient})
      : createClient = createClient ?? HttpClient.new;

  Future<dynamic> _json(Uri uri, {bool allowMissing = false}) async {
    final client = createClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      final response = await openUpdateUrl(client, uri);
      if (allowMissing && response.statusCode == 404) return null;
      if (response.statusCode == 403 || response.statusCode == 429) {
        throw const UpdateFailure('rateLimit');
      }
      if (response.statusCode != 200) throw const UpdateFailure('network');
      final bytes = <int>[];
      await for (final chunk in response.timeout(const Duration(seconds: 20))) {
        bytes.addAll(chunk);
        if (bytes.length > 1024 * 1024) throw const UpdateFailure('metadata');
      }
      return jsonDecode(utf8.decode(bytes));
    } finally {
      client.close(force: true);
    }
  }

  Future<UpdateRelease?> latest() async {
    final release = await _json(
        Uri.https('api.github.com', '/repos/$updateRepository/releases/latest'),
        allowMissing: true);
    if (release == null) return null;
    final source = (release as Map).cast<String, dynamic>();
    Map<String, dynamic>? manifest;
    for (final asset in source['assets'] as List) {
      if (asset['name'] == 'update.json') {
        final uri = Uri.parse(asset['browser_download_url'] as String);
        if (!trustedReleaseAsset(uri) ||
            uri.pathSegments.last != 'update.json' ||
            uri.pathSegments[uri.pathSegments.length - 2] !=
                source['tag_name']) {
          throw const UpdateFailure('source');
        }
        manifest = (await _json(uri) as Map).cast<String, dynamic>();
        break;
      }
    }
    return UpdateRelease.fromJson(source, manifest);
  }

  Future<List<UpdateRelease>> history() async {
    final releases = await _json(Uri.https('api.github.com',
        '/repos/$updateRepository/releases', {'per_page': '10'})) as List;
    return releases
        .where((r) => r['draft'] == false && r['prerelease'] == false)
        .map((r) => UpdateRelease.fromJson((r as Map).cast<String, dynamic>()))
        .toList();
  }
}

class UpdateDownloader {
  final HttpClient Function() createClient;
  UpdateDownloader({HttpClient Function()? createClient})
      : createClient = createClient ?? HttpClient.new;
  HttpClient? _client;
  bool _cancelled = false;

  void cancel() {
    _cancelled = true;
    _client?.close(force: true);
  }

  Future<void> download(
      UpdateAsset asset, String target, void Function(double) progress) async {
    if (!trustedReleaseAsset(asset.url)) throw const UpdateFailure('source');
    _cancelled = false;
    final client = createClient()
      ..connectionTimeout = const Duration(seconds: 15);
    _client = client;
    final part = File('$target.part');
    IOSink? sink;
    try {
      await part.parent.create(recursive: true);
      final response = await openUpdateUrl(client, asset.url);
      if (response.statusCode != 200) throw const UpdateFailure('network');
      if (response.contentLength >= 0 && response.contentLength != asset.size) {
        throw const UpdateFailure('integrity');
      }
      sink = part.openWrite();
      var received = 0;
      var lastProgress = -1.0;
      await for (final chunk in response.timeout(const Duration(seconds: 30))) {
        if (_cancelled) throw const UpdateFailure('cancelled');
        received += chunk.length;
        if (received > asset.size || received > maxUpdateBytes)
          throw const UpdateFailure('integrity');
        sink.add(chunk);
        await sink.flush();
        final fraction = received / asset.size;
        if (fraction - lastProgress >= 0.01) {
          progress(fraction);
          lastProgress = fraction;
        }
      }
      await sink.flush();
      await sink.close();
      sink = null;
      if (_cancelled) throw const UpdateFailure('cancelled');
      if (received != asset.size) throw const UpdateFailure('integrity');
      await part.rename(target);
      progress(1);
    } catch (_) {
      if (_cancelled) throw const UpdateFailure('cancelled');
      rethrow;
    } finally {
      await sink?.close();
      if (await part.exists()) await part.delete();
      client.close(force: true);
      if (identical(_client, client)) _client = null;
    }
  }
}
