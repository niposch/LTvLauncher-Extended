# Google TV Streamer rendering investigation

Measurements taken on 1 October 2026 with Flutter 3.24.5 in **profile mode** on a Google TV Streamer running Android 14. The display was 59.94 Hz (16.683 ms per frame). Android's launcher surface was 1920 × 1080, scaled to the 4K display. The device reported a 32-bit Android userspace, so the test APK included ARMv7 as well as ARM64.

## Cause and changes

The initial integrated launcher spent roughly 33–36 ms per frame on the raster thread while Dart builds usually stayed below 4 ms. An initial timeline showed much of the raster thread's time waiting in `AndroidContextGL::SwapBuffers` (mean 26.65 ms), with `LayerTree::Paint` averaging 2.59 ms. A minimal animated scene using the same Flutter engine stayed comfortably inside the frame budget.

The Pitch Black wallpaper still painted a full-screen black-to-black gradient and another translucent full-screen gradient over it. Removing these redundant layers while keeping the same visible black background removed the main bottleneck. A controlled comparison below changes only that background path; both versions use the corrected card surfaces. Wallpaper images and colored gradients retain their existing rendering path and were not validated to achieve these timings.

Card scaling, elevation, and idle dimming now use one 200 ms transition. Material's separate elevation animation and elevation tint are disabled. The easing is `easeOutCubic`, retaining the same focused sizes without the previous overshoot. Only the app gaining focus requests scrolling, avoiding competing scroll requests from the card losing focus.

Rounded corners had a separate problem: overlapping poster and scrim paints were each blended at the clipped edge, exposing a bright fringe. The card surface now composites these paints together before clipping, using a card-sized `antiAliasWithSaveLayer`. The scrim uses the surface's rounding, and the faint white idle border is removed. This follows Flutter's [clip documentation](https://api.flutter.dev/flutter/dart-ui/Clip.html) and [explanation of overlapping paints at clipped edges](https://api.flutter.dev/flutter/dart-ui/Canvas/saveLayer.html). The additional compositing cost is included in the final measurements.

## Controlled results

Pitch Black background, Modern theme, focus transitions and pulsing outline enabled, warm poster cache. Each capture selected the first card of the named row, waited two seconds, and sent ten right/left pairs with 300 ms pauses. The remote was left untouched. Continue Watching and app cards were tested separately.

| Row and background path | Frames | Raster median | Raster p95 | Frames over 16.683 ms in either stage |
| --- | ---: | ---: | ---: | ---: |
| Continue Watching, original gradients | 520 | 27.481 ms | 29.978 ms | 520 |
| Continue Watching, solid black | 546 | 6.382 ms | 10.390 ms | 4 (0.73%) |
| Apps, original gradients | 600 | 25.132 ms | 26.281 ms | 600 |
| Apps, solid black | 545 | 5.735 ms | 7.430 ms | 0 |

The final Continue Watching UI/build p95 was 3.169 ms; app-card UI/build p95 was 2.983 ms. These are Flutter frame-stage measurements, not a direct measurement of screen presentation or a benchmark of Google TV Home. They support near-60 fps navigation in this scene, with a few remaining long frames. Cold startup, new image downloads, different backgrounds, and other devices can produce different results.

## Reproduce

Use Flutter 3.24.5, an Android SDK, and a paired ADB device. Generate dependencies, mocks, and migration fixtures as in the release workflow. Database tests on Windows also need a compatible x64 `sqlite3.dll` on PATH.

```sh
flutter build apk --profile --target-platform=android-arm,android-arm64 -t tool/profile_launcher.dart
adb install -r build/app/outputs/flutter-apk/app-profile.apk
adb shell am start -W -n com.niposch.ltvlauncher.extended/com.leanbitlab.ltvL.MainActivity
adb logcat -d -s flutter
```

The last command prints the Dart VM service URL. Forward its device port with `adb forward tcp:8181 tcp:DEVICE_PORT`, and turn its URL into `ws://127.0.0.1:8181/AUTH_TOKEN/ws`. Pass that URL as `VM_URL` below (substitute it using your shell's variable syntax):

```sh
dart tool/profile_client.dart VM_URL focus row=posters index=0
# Wait two seconds, then start recording.
dart tool/profile_client.dart VM_URL start
# Send right/left keys repeatedly without launching a card.
adb shell input keyevent 22
adb shell input keyevent 21
# Wait one second for batched frame timings, then stop.
dart tool/profile_client.dart VM_URL stop
```

Use `focus row=apps index=0` for the app row. `trace` enables Dart/GC/Embedder timeline recording; `timeline OUTPUT_FILE` saves it. The optional `settings` command accepts `highlight=true`, `transition=true`, `continueWatching=true`, and `theme=modern`; these change the test installation's preferences. The profiler is an alternative entry point: normal builds use `lib/main.dart` and include none of these service extensions.

## Validation

The final full Flutter test suite passed: 275 tests, with two existing skips. Tests cover synchronized focus reversal, instant updates when animations are disabled, the solid black wallpaper path, and corner pixels that must never become brighter than the shaded artwork. The corner pixel regression fails with the old `antiAlias` clip and passes with the corrected compositing. Static analysis of the changed production code, new tests, and profiling tools passed. The normal release APK was built, signed with the local Android debug key for device testing, installed alongside upstream, and launched successfully.
