#!/usr/bin/env bash
# Erzeugt dist/rusty-teams-<ver>-x86_64.flatpak aus dem Release-Binary.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# shellcheck source=../common.sh
source "$ROOT/packaging/common.sh"

cd "$ROOT"

for cmd in flatpak flatpak-builder; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing $cmd (apt install flatpak flatpak-builder)" >&2
    exit 1
  fi
done

BIN="$(packaging_binary "$ROOT")"
ICON="$(packaging_icon "$ROOT")"
DESKTOP="$(packaging_desktop "$ROOT")"
VERSION="$(packaging_version "$ROOT")"
APP_ID=net.devops_geek.RustyTeams
MANIFEST="$ROOT/packaging/flatpak/${APP_ID}.yml"

STAGE="$ROOT/packaging/flatpak/stage"
WORKDIR="$ROOT/packaging/flatpak/.flatpak-build"
REPO="$ROOT/packaging/flatpak/.flatpak-repo"
mkdir -p "$STAGE" "$ROOT/dist"

install -m 755 "$BIN" "$STAGE/rusty-teams"
# Desktop/Icon auf Flatpak-App-ID umbiegen
sed \
  -e "s/^Exec=.*/Exec=rusty-teams/" \
  -e "s/^Icon=.*/Icon=${APP_ID}/" \
  "$DESKTOP" >"$STAGE/rusty-teams.desktop"
install -m 644 "$ICON" "$STAGE/rusty-teams.png"

cat >"$STAGE/${APP_ID}.metainfo.xml" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<component type="desktop-application">
  <id>${APP_ID}</id>
  <name>Rusty Teams</name>
  <summary>Native Microsoft Teams chat client</summary>
  <metadata_license>MIT</metadata_license>
  <project_license>MIT</project_license>
  <description>
    <p>A fast, native Teams client. Screen sharing uses the desktop ScreenCast portal on Wayland.</p>
  </description>
  <launchable type="desktop-id">${APP_ID}.desktop</launchable>
  <releases>
    <release version="${VERSION}" />
  </releases>
</component>
EOF

# Flathub-Runtime einmalig (CI-Cache bleibt im Workdir)
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo || true
flatpak install -y --user flathub org.freedesktop.Platform//24.08 org.freedesktop.Sdk//24.08 || true

rm -rf "$WORKDIR" "$REPO"
mkdir -p "$REPO"

flatpak-builder --user --force-clean --repo="$REPO" "$WORKDIR" "$MANIFEST"
out="$ROOT/dist/rusty-teams-${VERSION}-x86_64.flatpak"
flatpak build-bundle "$REPO" "$out" "$APP_ID"
echo "Wrote $out"
