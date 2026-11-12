#!/usr/bin/env bash
# Erzeugt dist/rusty-teams-<ver>-x86_64.pkg.tar.zst.
# Auf Ubuntu-CI: Arch-chroot via Podman/Docker (create + docker cp, kein Bind-Mount).
# Lokal auf Arch: makepkg direkt wenn makepkg verfügbar.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# shellcheck source=../common.sh
source "$ROOT/packaging/common.sh"

cd "$ROOT"

BIN="$(packaging_binary "$ROOT")"
ICON="$(packaging_icon "$ROOT")"
DESKTOP="$(packaging_desktop "$ROOT")"
VERSION="$(packaging_version "$ROOT")"
PKGVER="${VERSION//-/.}"
PKGREL=1

echo "Arch package pkgver=$PKGVER"

STAGE="$(mktemp -d)"
OUTDIR="$(mktemp -d)"
cleanup() { rm -rf "$STAGE" "$OUTDIR"; }
trap cleanup EXIT

cp "$ROOT/packaging/archlinux/PKGBUILD.prebuilt" "$STAGE/PKGBUILD"
sed -i "s/^pkgver=.*/pkgver=${PKGVER}/" "$STAGE/PKGBUILD"
sed -i "s/^pkgrel=.*/pkgrel=${PKGREL}/" "$STAGE/PKGBUILD"
install -m 755 "$BIN" "$STAGE/rusty-teams.bin"
install -m 644 "$DESKTOP" "$STAGE/rusty-teams.desktop"
install -m 644 "$ICON" "$STAGE/rusty-teams.png"

mkdir -p "$ROOT/dist"
out="$ROOT/dist/rusty-teams-${VERSION}-x86_64.pkg.tar.zst"

if command -v makepkg >/dev/null 2>&1; then
  (cd "$STAGE" && makepkg -f --noconfirm)
  built="$(find "$STAGE" -name 'rusty-teams-*.pkg.tar.zst' | head -1)"
  cp -f "$built" "$out"
  echo "Wrote $out"
  exit 0
fi

if ! command -v docker >/dev/null 2>&1 && ! command -v podman >/dev/null 2>&1; then
  echo "Need makepkg (Arch) or docker/podman for the Arch chroot" >&2
  exit 1
fi
ENGINE=docker
command -v docker >/dev/null 2>&1 || ENGINE=podman

cid="$($ENGINE create --name "rusty-teams-arch-$$" archlinux:latest sleep 3600)"
cleanup_ctr() {
  $ENGINE rm -f "$cid" >/dev/null 2>&1 || true
  cleanup
}
trap cleanup_ctr EXIT

$ENGINE start "$cid" >/dev/null
$ENGINE cp "$STAGE/." "$cid:/build/"
$ENGINE exec -u root "$cid" bash -lc '
  set -euo pipefail
  pacman -Sy --noconfirm --needed base-devel sudo archlinux-keyring
  useradd -m builduser
  echo "builduser ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/builduser
  chown -R builduser:builduser /build
  cd /build
  sudo -u builduser makepkg -f --noconfirm
'
$ENGINE cp "$cid:/build/." "$OUTDIR/"
built="$(find "$OUTDIR" -name 'rusty-teams-*.pkg.tar.zst' | head -1)"
[[ -n "$built" ]] || { echo "makepkg produced no package" >&2; exit 1; }
cp -f "$built" "$out"
echo "Wrote $out"
