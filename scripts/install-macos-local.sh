#!/usr/bin/env bash
# Native arm64 release .app with TEAMS_GOOGLE_* baked in (option_env!), then install to /Applications.
# Usage: source .env.google.local && scripts/install-macos-local.sh
set -euo pipefail
repoRoot="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repoRoot"
export PATH="$HOME/.cargo/bin:/usr/bin:/bin:/usr/local/bin:$PATH"

if [ -z "${TEAMS_GOOGLE_CLIENT_ID:-}" ] && [ -f "$repoRoot/.env.google.local" ]; then
  set -a
  # shellcheck disable=SC1091
  source "$repoRoot/.env.google.local"
  set +a
fi
if [ -z "${TEAMS_GOOGLE_CLIENT_ID:-}" ]; then
  echo "TEAMS_GOOGLE_CLIENT_ID missing (export or .env.google.local)" >&2
  exit 1
fi

echo "[$(date +%H:%M:%S)] START aarch64 release (client id set)"
cargo build -p app --release --bin teams --target aarch64-apple-darwin
BIN="$repoRoot/target/aarch64-apple-darwin/release/teams"
ls -la "$BIN"

APP="$repoRoot/target/universal/release/Rusty Teams.app"
version="$(sed -n 's/^version = "\(.*\)"/\1/p' "$repoRoot/Cargo.toml" | head -1)"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN" "$APP/Contents/MacOS/teams"
cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>Rusty Teams</string>
    <key>CFBundleDisplayName</key>
    <string>Rusty Teams</string>
    <key>CFBundleIdentifier</key>
    <string>org.rusty-teams.teams</string>
    <key>CFBundleExecutable</key>
    <string>teams</string>
    <key>CFBundleIconFile</key>
    <string>icon</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$version</string>
    <key>CFBundleVersion</key>
    <string>$version</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSMicrophoneUsageDescription</key>
    <string>Rusty Teams uses your microphone for calls.</string>
    <key>NSCameraUsageDescription</key>
    <string>Rusty Teams uses your camera for video calls.</string>
    <key>NSScreenCaptureUsageDescription</key>
    <string>Rusty Teams shares your screen in meetings.</string>
</dict>
</plist>
PLIST

iconset="$(mktemp -d)/teams.iconset"
mkdir -p "$iconset"
png="$repoRoot/crates/app/assets/icon/teams-fast-256.png"
for size in 16 32 64 128 256; do
  sips -z "$size" "$size" "$png" --out "$iconset/icon_${size}x${size}.png" >/dev/null
done
cp "$iconset/icon_32x32.png" "$iconset/icon_16x16@2x.png"
cp "$iconset/icon_64x64.png" "$iconset/icon_32x32@2x.png"
cp "$iconset/icon_256x256.png" "$iconset/icon_128x128@2x.png"
iconutil -c icns "$iconset" -o "$APP/Contents/Resources/icon.icns"

rm -rf "/Applications/Rusty Teams.app"
cp -R "$APP" "/Applications/Rusty Teams.app"
xattr -dr com.apple.quarantine "/Applications/Rusty Teams.app" 2>/dev/null || true

APP_BIN="/Applications/Rusty Teams.app/Contents/MacOS/teams"
if grep -aFq "apps.googleusercontent.com" "$APP_BIN"; then
  echo "[$(date +%H:%M:%S)] VERIFY ok: client id present in binary"
else
  echo "[$(date +%H:%M:%S)] VERIFY FAIL: client id missing from binary" >&2
  exit 1
fi
echo "[$(date +%H:%M:%S)] INSTALLED /Applications/Rusty Teams.app"
ls -la "$APP_BIN"
