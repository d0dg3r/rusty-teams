#!/usr/bin/env bash
# Erzeugt dist/rusty-teams-<ver>-x86_64.rpm aus dem Release-Binary.
# Voraussetzung: BINARY_PATH oder target/release/teams; rpmbuild.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# shellcheck source=../common.sh
source "$ROOT/packaging/common.sh"

cd "$ROOT"

if ! command -v rpmbuild >/dev/null 2>&1; then
  echo "Missing rpmbuild (apt install rpm / dnf install rpm-build)" >&2
  exit 1
fi

BIN="$(packaging_binary "$ROOT")"
ICON="$(packaging_icon "$ROOT")"
DESKTOP="$(packaging_desktop "$ROOT")"
VERSION="$(packaging_version "$ROOT")"
RPM_VERSION="$(printf '%s' "$VERSION" | tr '-' '~')"
PKG_NAME=rusty-teams
PKGREL=1

[[ -f "$ICON" ]] || { echo "Missing icon: $ICON" >&2; exit 1; }
[[ -f "$DESKTOP" ]] || { echo "Missing desktop: $DESKTOP" >&2; exit 1; }

echo "RPM package name=$PKG_NAME version=${RPM_VERSION}-${PKGREL}"

work="$(mktemp -d)"
cleanup() { rm -rf "$work"; }
trap cleanup EXIT

topdir="$work/rpmbuild"
for dir in BUILD BUILDROOT RPMS SOURCES SPECS SRPMS; do
  mkdir -p "$topdir/$dir"
done

install -m 755 "$BIN" "$topdir/SOURCES/rusty-teams"
install -m 644 "$ICON" "$topdir/SOURCES/rusty-teams.png"
install -m 644 "$DESKTOP" "$topdir/SOURCES/rusty-teams.desktop"

cat >"$topdir/SPECS/rusty-teams.spec" <<EOF
Name:           ${PKG_NAME}
Version:        ${RPM_VERSION}
Release:        ${PKGREL}%{?dist}
Summary:        Native Microsoft Teams chat client (fork)
License:        MIT
URL:            https://forgejo.lan/devops-geek/rusty-teams
Source0:        rusty-teams
Source1:        rusty-teams.png
Source2:        rusty-teams.desktop
BuildArch:      x86_64
Requires:       glib2, alsa-lib, fontconfig, libxkbcommon, libwayland-client
Recommends:     pipewire, xdg-desktop-portal

%description
A fast, native Teams client. Screen sharing uses the desktop ScreenCast portal on Wayland.

%install
mkdir -p %{buildroot}/opt/rusty-teams
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/share/applications
mkdir -p %{buildroot}/usr/share/icons/hicolor/256x256/apps
install -m 755 %{SOURCE0} %{buildroot}/opt/rusty-teams/rusty-teams
ln -sf /opt/rusty-teams/rusty-teams %{buildroot}/usr/bin/rusty-teams
ln -sf /opt/rusty-teams/rusty-teams %{buildroot}/usr/bin/teams
install -m 644 %{SOURCE1} %{buildroot}/usr/share/icons/hicolor/256x256/apps/rusty-teams.png
install -m 644 %{SOURCE2} %{buildroot}/usr/share/applications/rusty-teams.desktop

%files
/opt/rusty-teams/rusty-teams
/usr/bin/rusty-teams
/usr/bin/teams
/usr/share/icons/hicolor/256x256/apps/rusty-teams.png
/usr/share/applications/rusty-teams.desktop
EOF

rpmbuild --define "_topdir $topdir" -bb "$topdir/SPECS/rusty-teams.spec"
mkdir -p "$ROOT/dist"
rpm_out="$(find "$topdir/RPMS" -name '*.rpm' | head -1)"
out="$ROOT/dist/${PKG_NAME}-${VERSION}-x86_64.rpm"
cp -f "$rpm_out" "$out"
echo "Wrote $out"
