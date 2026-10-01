# Google TV Streamer rendering investigation

Measurements taken on 1 October 2026 with Flutter 3.24.5 in **profile mode** on a Google TV Streamer running Android 14. The display was 59.94 Hz (16.683 ms per frame). Android's launcher surface was 1920 × 1080, scaled to the 4K display. The device reported a 32-bit Android userspace, so the test APK included ARMv7 as well as ARM64.

## Cause and changes

The initial integrated launcher spent roughly 33–36 ms per frame on the raster thread while Dart builds usually stayed below 4 ms. An initial timeline showed much of the raster thread's time waiting in `AndroidContextGL::SwapBuffers` (mean 26.65 ms), with `LayerTree::Paint` averaging 2.59 ms. A minimal animated scene using the same Flutter engine stayed comfortably inside the frame budget.

The Pitch Black wallpaper still painted a full-screen black-to-black gradient and another translucent full-screen gradient over it. Removing these redundant layers while keeping the same visible black background removed the main bottleneck. The first controlled comparison below changes only that background path; both versions use the corrected card surfaces.

The follow-up investigation applied the same lesson to wallpaper images and colored gradients. Their existing `RepaintBoundary` retained a display list but did not eliminate the full-screen shader/compositing cost. A `CustomPaint` now draws the identical scrim with `isComplex: true`, enabling the compositor to cache the combined static background. The engine invalidates the cached layer when its content or size changes. Flutter documents the distinction between [repaint isolation and optional raster caching](https://api.flutter.dev/flutter/widgets/RepaintBoundary-class.html) and the [explicit raster-cache hint](https://api.flutter.dev/flutter/widgets/CustomPaint/isComplex.html). The device comparisons support this explanation; they do not inspect Google TV Home's implementation.

Gradient selection also notified listeners before its asynchronous preferences update completed, sometimes leaving the previous background visible. It now waits for the new setting and refreshes the active wallpaper before notifying.

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

The Continue Watching UI/build p95 in this initial comparison was 3.169 ms; app-card UI/build p95 was 2.983 ms.

### Wider scrolling with non-black backgrounds

The follow-up capture moved **eight Continue Watching cards right, then eight left, repeated twice**, with 300 ms pauses. This exercises horizontal scrolling and cards entering the viewport, rather than just switching between the first two. Each run waited for the row to exist, focused its first card, and allowed two seconds before recording. The Modern theme, transitions, and pulsing outline remained enabled. The image fixture was a JPEG copied from the installation's existing poster cache into its otherwise empty wallpaper file; it was removed afterward through gradient selection.

| Background and path | Frames | Raster median | Raster p95 | Frames over 16.683 ms in either stage |
| --- | ---: | ---: | ---: | ---: |
| Great Whale linear gradient, original | 653 | 28.585 ms | 30.688 ms | 653 |
| Great Whale linear gradient, cached | 1,123 | 6.575 ms | 10.524 ms | 0 |
| Image wallpaper, original | 966 | 18.334 ms | 21.289 ms | 924 (95.65%) |
| Image wallpaper, cached | 1,110 | 6.335 ms | 11.970 ms | 15 (1.35%) |
| Old Hat radial gradient, cached | 1,108 | 6.078 ms | 9.377 ms | 0 |

These are Flutter frame-stage measurements, not a direct measurement of screen presentation or a benchmark of Google TV Home. The tested gradients met the frame budget throughout their wider captures. The image wallpaper had a few remaining long frames. Cold startup, new image downloads, very large images, changing backgrounds, and other devices can produce different results. A background being visually detailed does not require it to be recomputed every animation frame.

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
# For a wider test, send eight rights then eight lefts and repeat twice.
# Wait one second for batched frame timings, then stop.
dart tool/profile_client.dart VM_URL stop
```

Use `focus row=apps index=0` for the app row. `trace` enables Dart/GC/Embedder timeline recording; `timeline OUTPUT_FILE` saves it. The optional `settings` command accepts `highlight=true`, `transition=true`, `continueWatching=true`, `theme=modern`, and a gradient name or UUID such as `"gradient=Great Whale"`. These use the normal settings and wallpaper APIs; gradient selection replaces a manual wallpaper. Restore the previous background after testing. The profiler is an alternative entry point: normal builds use `lib/main.dart` and include none of these service extensions.

## Validation

The final full Flutter test suite passed: 278 tests, with two existing skips. Tests cover synchronized focus reversal, instant updates when animations are disabled, the solid black wallpaper path, and corner pixels that must never become brighter than the shaded artwork. The corner pixel regression fails with the old `antiAlias` clip and passes with the corrected compositing. Additional tests compare the original and cached linear/radial backgrounds byte-for-byte and verify listeners see the new gradient after preferences finish saving. Static analysis of the changed production code, new tests, and profiling tools passed. The normal release APK was built, signed with the local Android debug key for device testing, installed alongside upstream, and launched successfully.
