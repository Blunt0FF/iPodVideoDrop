#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/iPodVideoDrop/main.m"
APP="$ROOT/iPod Video Drop.app"
OUT="$ROOT/.build"
SDK="$(xcrun --sdk macosx --show-sdk-path)"
CLANG="$(xcrun --sdk macosx --find clang)"
ICONSET="$OUT/iPodVideoDrop.iconset"
ICON="$ROOT/iPodVideoDropIcon.png"

echo "Building iPod Video Drop..."
[ -f "$SRC" ] || { echo "Error: missing source: $SRC"; exit 1; }
[ -f "$ICON" ] || { echo "Error: missing icon: $ICON"; exit 1; }
rm -rf "$OUT" "$APP"
mkdir -p "$OUT/$APP/Contents/MacOS" "$OUT/$APP/Contents/Resources" "$ICONSET"

for spec in \
  "16 icon_16x16.png" \
  "32 icon_16x16@2x.png" \
  "32 icon_32x32.png" \
  "64 icon_32x32@2x.png" \
  "128 icon_128x128.png" \
  "256 icon_128x128@2x.png" \
  "256 icon_256x256.png" \
  "512 icon_256x256@2x.png" \
  "512 icon_512x512.png" \
  "1024 icon_512x512@2x.png"; do
  size="${spec%% *}"
  name="${spec#* }"
  sips -z "$size" "$size" "$ICON" --out "$ICONSET/$name" >/dev/null
done

iconutil -c icns "$ICONSET" -o "$OUT/iPodVideoDrop.icns"
[ -f "$OUT/iPodVideoDrop.icns" ] || { echo "Error: icon conversion failed"; exit 1; }

"$CLANG" -fobjc-arc -Wall -Wextra -O2 -mmacosx-version-min=12.0 -isysroot "$SDK" -framework Cocoa "$SRC" -o "$OUT/$APP/Contents/MacOS/iPodVideoDrop"

cat > "$OUT/$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleName</key><string>iPod Video Drop</string>
<key>CFBundleDisplayName</key><string>iPod Video Drop</string>
<key>CFBundleIdentifier</key><string>local.ipodvideodrop</string>
<key>CFBundleExecutable</key><string>iPodVideoDrop</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>LSMinimumSystemVersion</key><string>12.0</string>
<key>NSHighResolutionCapable</key><true/>
<key>CFBundleIconFile</key><string>iPodVideoDrop.icns</string>
</dict></plist>
PLIST

cp "$OUT/iPodVideoDrop.icns" "$OUT/$APP/Contents/Resources/iPodVideoDrop.icns"
cp -R "$OUT/$APP" "$APP"
rm -rf "$OUT"
echo "Build successful: $APP"
