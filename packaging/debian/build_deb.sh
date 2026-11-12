#!/usr/bin/env bash
# Erzeugt dist/rusty-teams-<ver>-amd64.deb aus dem Release-Binary.
# Voraussetzung: BINARY_PATH oder target/release/teams; dpkg-deb.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# shellcheck source=../common.sh
source "$ROOT/packaging/common.sh"

cd "$ROOT"

if ! command -v dpkg-deb >/dev/null 2>&1; then
  echo "Missing dpkg-deb (apt install dpkg-dev)" >&2
  exit 1
fi

BIN="$(packaging_binary "$ROOT")"
ICON="$(packaging_icon "$ROOT")"
DESKTOP="$(packaging_desktop "$ROOT")"
VERSION="$(packaging_version "$ROOT")"
# Debian: Prerelease mit ~ sortiert vor Final.
DEB_UPSTREAM="$(printf '%s' "$VERSION" | tr '-' '~')"
DEB_VERSION="${DEB_UPSTREAM}-1"
PKG_NAME=rusty-teams
OPT_DIR=/opt/rusty-teams

[[ -f "$ICON" ]] || { echo "Missing icon: $ICON" >&2; exit 1; }
[[ -f "$DESKTOP" ]] || { echo "Missing desktop: $DESKTOP" >&2; exit 1; }

echo "Debian package name=$PKG_NAME version=$DEB_VERSION"

work="$(mktemp -d)"
cleanup() { rm -rf "$work"; }
trap cleanup EXIT

pkgroot="$work/pkg"
mkdir -p \
  "$pkgroot/DEBIAN" \
  "$pkgroot$OPT_DIR" \
  "$pkgroot/usr/bin" \
  "$pkgroot/usr/share/applications" \
  "$pkgroot/usr/share/icons/hicolor/256x256/apps"

install -m 755 "$BIN" "$pkgroot$OPT_DIR/rusty-teams"
ln -sf "$OPT_DIR/rusty-teams" "$pkgroot/usr/bin/rusty-teams"
ln -sf "$OPT_DIR/rusty-teams" "$pkgroot/usr/bin/teams"
install -m 644 "$ICON" "$pkgroot/usr/share/icons/hicolor/256x256/apps/rusty-teams.png"
# Desktop Exec bleibt «teams» (Symlink); Icon-Name rusty-teams.
install -m 644 "$DESKTOP" "$pkgroot/usr/share/applications/rusty-teams.desktop"

cat >"$pkgroot/DEBIAN/control" <<EOF
Package: $PKG_NAME
Version: $DEB_VERSION
Section: net
Priority: optional
Architecture: amd64
Maintainer: devops-geek <admin@devops-geek.net>
Depends: libglib2.0-0, libasound2 | libasound2t64, libfontconfig1, libxkbcommon0, libwayland-client0
Recommends: pipewire, xdg-desktop-portal
Description: Native Microsoft Teams chat client (fork)
 A fast, native Teams client. Screen sharing uses the desktop ScreenCast portal on Wayland.
EOF

mkdir -p "$ROOT/dist"
out="$ROOT/dist/${PKG_NAME}-${VERSION}-amd64.deb"
dpkg-deb --root-owner-group --build "$pkgroot" "$out"
echo "Wrote $out"
