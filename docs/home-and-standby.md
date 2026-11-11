# Home and standby behavior

Enable **LTv Extended Home Button Fix** in Android accessibility settings.
Keep the stock launcher installed and enabled. **Start on boot** is separate:
it handles a full reboot, not standby wake.

The accessibility service watches screen on/off and window state changes.
For ten seconds after screen-on it can return to Extended if the active window
belongs to another registered HOME activity. It waits 500 ms for windows to settle,
checks the currently active window package, and redirects at most once per wake.
Playback apps, settings and unrelated windows do not match HOME activities.
Enabling the service while already awake does not start a wake redirect.
It inspects only package/class metadata, never window text. Debug builds log that metadata under `LTvHome`; release builds do not.

Home starts/reuses the single-task launcher activity with a HOME intent.
A buffered Android event tells Flutter to dismiss routes above the launcher,
including drawers with nested navigation and modal dialogs, and exit its clock view.
Ordinary activity resume leaves settings/navigation open.

The default-launcher status queries Android’s Home role on Android 10+,
then the preferred Home component on older/non-role devices, with intent resolution
as the final fallback. This distinguishes user selection from vendor HOME priority.

## Verification

Automated coverage: bounded wake eligibility, non-home/changed windows, asleep
state, one-shot consumption, Home dismissing nested drawers and dialogs, retaining
the root route, clock restoration, and refreshing default status after resume.

For device testing, exercise Home while settings is open (including a submenu
and a dialog), and Home while the launcher clock is shown. Select Extended in
Android’s default-home picker and confirm the indicator after returning. Choose
another launcher and confirm that the indicator updates back.

Put the device into standby while on the stock home screen, then wake with the
remote’s Power button or HDMI-CEC. Extended should appear after the home window
settles. Repeat while in a playback app: the playback app should remain in front.
Also check quick settings, system settings, repeated wake cycles, and a full reboot
with Start on boot enabled. Disable Home Button Fix to verify redirects stop.
Actual firmware-specific wake behavior requires device testing; a build or unit
test alone cannot establish HDMI-CEC reliability.

## Validation on 2026-10-03

- 298 Flutter tests passed, with two existing skips. Seven native wake-policy
  tests passed. Analysis of changed helpers, channel/state code and Home tests
  reported no issues; the existing app theme and older test fixture retain
  pre-existing Flutter deprecation notices.
- Both ARMv7/ARM64 universal debug and release APKs built successfully.
  APK metadata confirms the separate debug package and **LTv Extended (Debug)**
  label, debug-specific icon/banner resources, and normal release artwork.
- On a Google TV Streamer running Android 14, Android's selected Home role was
  Extended while intent resolution still chose Google TV. The corrected indicator
  was verified against the Home role using the separate debug installation.
- A HOME intent dismissed an open Accessibility submenu on the device; widget
  coverage also verifies a nested drawer plus modal dialog, clock restoration,
  and retaining settings on ordinary resume. The physical remote's key filtering
  still requires an owner check; injected ADB Home keys are not equivalent to
  accessibility-filtered remote events.
- One standby/power-key cycle returned from Google TV Home to the debug launcher.
  Later attempts were interrupted by HDMI putting the device back to sleep;
  HDMI One Touch Play timed out. Repeated remote/CEC wake, actual playback resume,
  and full reboot behavior were not established by those attempts.
- The debug badge and refined small purple bug mark on the TV tile were visually
  checked. The final release update used the existing release signing key and
  preserved app data. The original release Home role and accessibility service
  selection were restored; Debug remains installed alongside Release with its
  own independent settings/permissions. No stock launcher package was disabled.

Local APKs are build artifacts, not a published release. The existing version
number remains unchanged until a release is requested.

The debug icon/banner marker now uses Google's standard Material `bug_report` glyph instead of custom bug geometry. The source and Apache 2.0 license are recorded in `ATTRIBUTION.md`; the license is packaged only in debug APKs.

The APK rebuilt successfully after this asset replacement, was installed as the separate debug package, and the updated Material bug marker was visually checked on the TV app tile.
