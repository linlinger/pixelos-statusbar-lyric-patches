# PixelOS Status Bar Lyric Patches (Android 17)

Meizu Flyme-style status bar lyric (ticker mode + LRCLIB fallback) for **PixelOS Android 17**, ported from **Evolution-X branch `cnb`**.

## What you get

- Status bar lyric rendered from music apps' Flyme ticker notifications
- Automatic device-props disguise for 8 music apps (NetEase Cloud Music, QQ Music, KuGou, Kuwo, Migu, Honor Music...) so they publish ticker lyric notifications out of the box (prop: `persist.sys.disguise_props_for_music_app`, default `true`, toggleable in Settings)
- LRCLIB lyrics fetching as fallback (works without app cooperation)
- Toggle in **Settings > Display > Other display controls > Status bar lyric**

## Patches

### frameworks/base

| Patch | Description | Original commit |
|---|---|---|
| `0001` | Add status bar lyric | Evolution-X `b53bc2c6acc0` |
| `0002` | Follow-ups: LyricsFetcher (LRCLIB), remove broken app icon, lazy register | Evolution-X `d21f19e7e3ca`, `743453ac7a16`, `38d04ec71e4b` |
| `0003` | Disguise props for music apps (MeizuPropsUtils) | Evolution-X `20ba25ae0038` |
| `0004` | Expose ticker flags as public API | PixelOS-specific, required on A17 (see below) |

### packages/apps/Settings

| Patch | Description | Original commit |
|---|---|---|
| `0001` | Add status bar lyric toggle to display settings | Evolution-X (Evolver) `2d2e69a788b5` |
| `0002` | Add disguise device for music apps toggle (below the lyric switch, backed by `persist.sys.disguise_props_for_music_app`, ported from PixelExperience) | PixelExperience `91fdc755` lineage |

## Why 0004 is required on Android 17

Android 17's hidden-API enforcement classifies `Notification.FLAG_ALWAYS_SHOW_TICKER` (0x01000000) and `Notification.FLAG_ONLY_UPDATE_TICKER` (0x02000000) as `blocked`. Music apps reach these flags via reflection, so without exposing them the lyric support detection always fails (`NoSuchFieldException`). This patch removes the `@hide` annotation and registers both flags in `core/api/current.txt`.

**A full rebuild is required** — hidden-API metadata is baked into the boot dex at build time and cannot be patched at runtime.

## Usage

```bash
# from the root of your Android source tree
git clone https://github.com/linlinger/pixelos-statusbar-lyric-patches.git
cd pixelos-statusbar-lyric-patches
bash apply.sh
# then rebuild frameworks/base and packages/apps/Settings
```

`apply.sh` uses `git am -3` first and falls back to `git apply --reject` on conflicts. Patch authorship (the `From:` header of each patch) is preserved from the original Evolution-X commits, so `git am` keeps proper attribution.

## Credits

| Author | Contribution |
|---|---|
| [cjybyjk](https://github.com/cjybyjk) | Original status bar lyric implementation (`b53bc2c6acc0`), music-app props reset (`20ba25ae0038`) |
| [Ghosuto](https://github.com/Ghosuto) | LyricsFetcher for LRCLIB synced/plain lyrics, app icon removal (`d21f19e7e3ca`, `743453ac7a16`) |
| [joshuah345](https://github.com/joshuah345) (hiroshi.) | Lazy LyricsFetcher callback registration (`38d04ec71e4b`) |
| [KujouYuko](https://github.com/KujouYuko) | Evolver toggle (`2d2e69a788b5`) |
| [linlinger](https://github.com/linlinger) | PixelOS port & adaptation, hidden-API exposure fix (`0004`), Settings toggle ports (`Settings 0001`/`0002`) |

All patches are extracted/integrated for PixelOS; the underlying feature is the work of the Evolution-X team and the authors listed above.
