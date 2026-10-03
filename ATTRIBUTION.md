# Attribution

LTv Extended is a derivative of [LTvLauncher by LeanBitLab](https://github.com/leanbitlab-org/LtvLauncher), which is based on [osrosal's FLauncher fork](https://github.com/osrosal/flauncher) and [FLauncher by Étienne Fesser](https://gitlab.com/flauncher/flauncher). Existing copyright notices and the [GNU GPL v3 license](LICENSE) are retained.

The following commits from [hamishakl/LtvLauncher, branch `posters`](https://github.com/hamishakl/LtvLauncher/tree/posters) were authored by **hamish henare** and integrated with their original authorship and history:

| Commit | Contribution |
| --- | --- |
| [b803283](https://github.com/hamishakl/LtvLauncher/commit/b803283) | Poster cards for Continue Watching |
| [9d7be2e](https://github.com/hamishakl/LtvLauncher/commit/9d7be2e) | Disk cache and downscaling for remote posters |
| [7e6ff96](https://github.com/hamishakl/LtvLauncher/commit/7e6ff96) | Open-Meteo weather and Jellyfin Next Up / Recently Added rows |
| [34b29ab](https://github.com/hamishakl/LtvLauncher/commit/34b29ab) | Seerr For You recommendations |

Integration, the distinct Android application ID, compatibility fixes, rendering performance and rounded-corner fixes, optional weather details and city selection, and LTv Extended branding in this repository were assisted by **Codex (OpenAI)**. The updated icon and TV banner retain the upstream TV mark and were edited with OpenAI's imagegen tool. New commits for this work include `Co-authored-by: Codex <codex@openai.com>`; the imported upstream commits retain their original authorship without modification.

Weather forecasts and city search use [Open-Meteo](https://open-meteo.com/). City search data is provided by [GeoNames](https://www.geonames.org/), as credited by the [Open-Meteo Geocoding API](https://open-meteo.com/en/docs/geocoding-api).

Documentation screenshots use fictional programs and original procedural landscape artwork created with Codex assistance. The illustrations and fictional metadata are dedicated to the public domain under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/); launcher UI and source retain their existing licenses. See [the capture setup](docs/screenshots.md) for the separate, reproducible screenshot branch.

The debug icon and TV banner use Google's [Material Icons `bug_report` glyph](https://github.com/google/material-design-icons/blob/master/src/action/bug_report/materialicons/24px.svg), under the [Apache License 2.0](android/app/src/debug/res/raw/material_icons_license.txt). Its original SVG geometry is converted to Android VectorDrawable and recolored; the license is included in debug APK resources.
