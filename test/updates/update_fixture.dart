import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flauncher/updates/github_update_client.dart';
import 'package:flauncher/updates/update_channel.dart';
import 'package:flauncher/updates/update_release.dart';

Map<String, dynamic> source({String tag = 'v2026.10.02'}) => {
      'tag_name': tag,
      'name': tag,
      'body': '## Changes\n- Fixed Home navigation',
      'published_at': '2026-10-02T12:00:00Z',
      'draft': false,
      'prerelease': false,
      'html_url': 'https://github.com/$updateRepository/releases/tag/$tag',
      'assets': [
        {
          'name': universalApk,
          'size': 3,
          'browser_download_url':
              'https://github.com/$updateRepository/releases/download/$tag/$universalApk'
        }
      ],
    };
Map<String, dynamic> manifest({int code = 8113}) => {
      'schemaVersion': 1,
      'packageName': releasePackage,
      'versionName': '2026.10.02',
      'versionCode': code,
      'changelog': '- Fixed Home navigation',
      'assets': [
        {'name': universalApk, 'size': 3, 'sha256': 'a' * 64}
      ],
    };
UpdateRelease nextRelease({int code = 8113}) =>
    UpdateRelease.fromJson(source(), manifest(code: code));

class FakeUpdateApi extends GitHubUpdateClient {
  int calls = 0;
  UpdateRelease? value = nextRelease();
  Object? failure;
  Completer<UpdateRelease?>? pending;
  @override
  Future<UpdateRelease?> latest() async {
    calls++;
    if (failure != null) throw failure!;
    return pending == null ? value : await pending!.future;
  }

  @override
  Future<List<UpdateRelease>> history() async => [value!];
}

class FakeUpdateChannel extends UpdateChannel {
  bool debug = false, canInstall = true;
  int installs = 0, allows = 0;
  String? lastDigest;
  int? lastCode;
  @override
  Future<InstalledUpdateInfo> info() async => InstalledUpdateInfo(
      versionName: '2026.10.01',
      versionCode: 8112,
      packageName: debug ? '$releasePackage.debug' : releasePackage,
      debug: debug,
      canInstall: canInstall,
      updatePath: '/test/update.apk');
  @override
  Future<void> allowInstalls() async {
    allows++;
  }

  @override
  Future<String> install(String sha256, int versionCode) async {
    installs++;
    lastDigest = sha256;
    lastCode = versionCode;
    return canInstall ? 'installerOpened' : 'permissionRequired';
  }
}

class FakeDownloader extends UpdateDownloader {
  int downloads = 0;
  @override
  Future<void> download(
      UpdateAsset asset, String target, void Function(double) progress) async {
    downloads++;
    progress(1);
  }
}

class FakeHeaders implements HttpHeaders {
  final Map<String, String> values;
  FakeHeaders([this.values = const {}]);
  @override
  String? value(String name) => values[name];
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeResponse extends Stream<List<int>> implements HttpClientResponse {
  final List<List<int>> chunks;
  @override
  final int statusCode;
  @override
  final HttpHeaders headers;
  @override
  final int contentLength;
  FakeResponse(String body,
      {this.statusCode = 200, Map<String, String> headers = const {}})
      : chunks = [utf8.encode(body)],
        contentLength = utf8.encode(body).length,
        headers = FakeHeaders(headers);
  FakeResponse.chunks(this.chunks,
      {this.statusCode = 200, this.contentLength = -1})
      : headers = FakeHeaders();
  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData,
          {Function? onError, void Function()? onDone, bool? cancelOnError}) =>
      Stream.fromIterable(chunks).listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeRequest implements HttpClientRequest {
  final HttpClientResponse response;
  FakeRequest(this.response);
  @override
  bool followRedirects = false;
  @override
  HttpHeaders get headers => FakeHeaders();
  @override
  Future<HttpClientResponse> close() async => response;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeHttpClient implements HttpClient {
  final List<HttpClientResponse> responses;
  final List<Uri> requested = [];
  FakeHttpClient(this.responses);
  @override
  Duration? connectionTimeout;
  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    requested.add(url);
    return FakeRequest(responses.removeAt(0));
  }

  @override
  void close({bool force = false}) {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
