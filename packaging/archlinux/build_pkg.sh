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

# Prefer the main package over rusty-teams-debug-*.pkg.tar.zst.
pick_main_pkg() {
  local dir="$1"
  local built
  built="$(
    find "$dir" -maxdepth 1 -type f -name 'rusty-teams-*.pkg.tar.zst' \
      ! -name 'rusty-teams-debug-*' | head -1
  )"
  [[ -n "$built" ]] || {
    echo "makepkg produced no main package in $dir" >&2
    find "$dir" -maxdepth 1 -name '*.pkg.tar.zst' -ls >&2 || true
    return 1
  }
  local size
  size="$(stat -c '%s' "$built")"
  # Desktop + icon alone are a few KiB; a real payload is tens of MiB.
  if [[ "$size" -lt 1048576 ]]; then
    echo "Arch package looks empty (${size} bytes): $built" >&2
    tar -tvf "$built" >&2 || true
    return 1
  fi
  printf '%s\n' "$built"
}

if command -v makepkg >/dev/null 2>&1; then
  (cd "$STAGE" && makepkg -f --noconfirm)
  built="$(pick_main_pkg "$STAGE")"
  cp -f "$built" "$out"
  echo "Wrote $out ($(stat -c '%s' "$out") bytes)"
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
  pacman -Sy --noconfirm --needed \
    base-devel sudo archlinux-keyring \
    glib2 alsa-lib fontconfig libxkbcommon wayland
  useradd -m builduser
  echo "builduser ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/builduser
  chown -R builduser:builduser /build
  cd /build
  # Prebuilt binary: skip dependency resolution in the chroot (-d).
  sudo -u builduser makepkg -df --noconfirm
'
$ENGINE cp "$cid:/build/." "$OUTDIR/"
built="$(pick_main_pkg "$OUTDIR")"
cp -f "$built" "$out"
echo "Wrote $out ($(stat -c '%s' "$out") bytes)"
