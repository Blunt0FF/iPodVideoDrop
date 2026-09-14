# iPod Video Drop

Native macOS app (Cocoa/Objective-C) that converts video into the format iPod nano 7 lists under **Movies** (instead of "Music Videos" or anything else carrying artist/album metadata).

Drag a video file into the window and get an `.m4v` back, ready to sync through the Apple TV app (or iTunes on older macOS) and correctly recognized by iPod nano 7 as a movie.

## What it does

- Converts video to H.264 Baseline, Level 3.0, yuv420p, up to 640×480, 30 fps CFR
- Audio: AAC-LC, 160 kbps, stereo, 44.1 kHz
- Writes metadata via AtomicParsley: `stik=value=9` (content type **Movie**), so the file lands in "Movies" on the iPod, without the artist/album fields typical of music videos
- Automatically detects portrait video and rotates it 90° before scaling into the 640×480 landscape frame
- Output file: `<original name>_iPod.m4v` next to the source
- No completion popup — just watch the status in the app itself; ⌘Q quits

## Requirements

- macOS 12.0 (Monterey) or later
- Xcode Command Line Tools (to build from source)
- `ffmpeg` and `AtomicParsley` — the app looks for them in `/opt/homebrew/bin`, `/usr/local/bin`, `/usr/bin`, or offers to install them via Homebrew right from the UI (`brew install ffmpeg atomicparsley`)

Install dependencies ahead of time:

```bash
brew install ffmpeg atomicparsley
```

## Build

```bash
git clone git@github.com:Blunt0FF/iPodVideoDrop.git
cd iPodVideoDrop
./build.command
```

The script builds `iPod Video Drop.app` in the repo root (the icon is generated from `iPodVideoDropIcon.png`). Drag the resulting app into `/Applications`.

Or grab a prebuilt binary from [Releases](../../releases) — no Xcode required.

## Usage

1. Launch `iPod Video Drop.app`.
2. If ffmpeg/AtomicParsley aren't found, the app offers to install them via Homebrew.
3. Drag one or more video files into the window — conversion starts automatically.
4. The resulting `<name>_iPod.m4v` appears next to the source file.
5. Sync via the **TV** app (or iTunes) on your Mac → iPod nano 7 — the file lands in **Movies**.

### About `main-horizontal.m`

`iPodVideoDrop/` also contains `main-horizontal.m` — an earlier variant of the converter without portrait-video auto-rotation. The build script uses the main `main.m`; this file is kept for reference/comparison and is not part of the build.

## License

[MIT](LICENSE)
