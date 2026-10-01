import 'dart:io';

import 'package:image/image.dart' as image;

/// Export the imagegen banner to the Android TV resource size.
/// The square source is converted to launcher densities by flutter_launcher_icons.
void main() {
  final banner = image.decodePng(File('assets/banner.png').readAsBytesSync())!;
  final resized = image.copyResize(banner,
      width: 320, height: 180, interpolation: image.Interpolation.cubic);
  final bytes = image.encodePng(resized);
  for (final name in [
    'android/app/src/main/res/drawable/banner.png',
    'android/app/src/main/res/drawable-xhdpi/banner.png',
  ]) {
    File(name).writeAsBytesSync(bytes);
  }
  File('fastlane/metadata/android/en-US/images/icon.png')
      .writeAsBytesSync(File('assets/icon.png').readAsBytesSync());
}
