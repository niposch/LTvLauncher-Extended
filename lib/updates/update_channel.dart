import 'package:flutter/services.dart';

class InstalledUpdateInfo {
  final String versionName, packageName, updatePath;
  final int versionCode;
  final bool debug, canInstall;
  const InstalledUpdateInfo(
      {required this.versionName,
      required this.packageName,
      required this.versionCode,
      required this.debug,
      required this.canInstall,
      required this.updatePath});
}

class UpdateChannel {
  static const channel =
      MethodChannel('com.niposch.ltvlauncher.extended/updates');
  Future<InstalledUpdateInfo> info() async {
    final info = (await channel.invokeMapMethod<String, dynamic>('info'))!;
    return InstalledUpdateInfo(
        versionName: info['versionName'],
        packageName: info['packageName'],
        versionCode: info['versionCode'],
        debug: info['debug'],
        canInstall: info['canInstall'],
        updatePath: info['updatePath']);
  }

  Future<void> allowInstalls() => channel.invokeMethod('allowInstalls');
  Future<String> install(String sha256, int versionCode) async =>
      (await channel.invokeMethod<String>(
          'install', {'sha256': sha256, 'versionCode': versionCode}))!;
}
