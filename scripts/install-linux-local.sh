#!/usr/bin/env bash
# Release Linux binary with TEAMS_GOOGLE_* baked in, then install that binary
# only through the Arch package (pacman). No second copy under ~/.local or /usr/local.
# Usage: scripts/install-linux-local.sh [--restart]
# Loads .env.google.local when TEAMS_GOOGLE_CLIENT_ID is not exported. Without the client id
# the app silently drops every Google calendar; without the Desktop client secret, token refresh
# fails and the week stays empty — refuse both missing id and missing secret.
set -euo pipefail
repoRoot="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repoRoot"
export PATH="/usr/bin:/bin:/usr/local/bin:/usr/sbin:/sbin:$HOME/.cargo/bin:$PATH"

restart=false
for arg in "$@"; do
  case "$arg" in
    --restart) restart=true ;;
    *) echo "unknown argument: $arg" >&2; exit 2 ;;
  esac
done

# Fill missing id/secret from .env.google.local (env already set wins for that key only if we
# source when either is empty — file values fill gaps after a partial export).
if { [ -z "${TEAMS_GOOGLE_CLIENT_ID:-}" ] || [ -z "${TEAMS_GOOGLE_CLIENT_SECRET:-}" ]; } \
  && [ -f "$repoRoot/.env.google.local" ]; then
  set -a
  # shellcheck disable=SC1091
  source "$repoRoot/.env.google.local"
  set +a
fi
if [ -z "${TEAMS_GOOGLE_CLIENT_ID:-}" ]; then
  echo "TEAMS_GOOGLE_CLIENT_ID missing (export it or create .env.google.local)" >&2
  exit 1
fi
if [ -z "${TEAMS_GOOGLE_CLIENT_SECRET:-}" ]; then
  echo "TEAMS_GOOGLE_CLIENT_SECRET missing (Desktop clients need it for token refresh)" >&2
  exit 1
fi

# Always build: cargo tracks option_env!, so a binary built without the id gets rebuilt.
echo "[$(date +%H:%M:%S)] building release…"
cargo build -p app --release --bin teams

BIN="$repoRoot/target/release/teams"
if ! grep -aFq "apps.googleusercontent.com" "$BIN"; then
  echo "client id not in binary — rebuild with TEAMS_GOOGLE_CLIENT_ID set" >&2
  exit 1
fi
# Desktop secret prefix only — never echo the secret value.
if ! grep -aFq "GOCSPX-" "$BIN"; then
  echo "client secret not in binary — rebuild with TEAMS_GOOGLE_CLIENT_SECRET set" >&2
  exit 1
fi

# Same label as the installed package (changelog heading), so pacman does not
# downgrade 0.6.1.joe.3 to the Cargo version 0.6.1.
release="$(sed -n 's/^## \[\([^]]*\)\].*/\1/p; t found; b; :found q' "$repoRoot/CHANGELOG.md")"
if [ -z "$release" ]; then
  echo "no version heading in CHANGELOG.md" >&2
  exit 1
fi
export RELEASE_VERSION="$release"
echo "[$(date +%H:%M:%S)] packaging $RELEASE_VERSION…"
"$repoRoot/packaging/archlinux/build_pkg.sh"
pkg="$repoRoot/dist/rusty-teams-${RELEASE_VERSION}-x86_64.pkg.tar.zst"
if [ ! -f "$pkg" ]; then
  echo "package not written: $pkg" >&2
  exit 1
fi

echo "[$(date +%H:%M:%S)] stopping any running teams"
pkill -x rusty-teams 2>/dev/null || true
pkill -x teams 2>/dev/null || true
sleep 1
rm -f "${XDG_RUNTIME_DIR:-/tmp}/rusty-teams-${USER}.sock"

echo "[$(date +%H:%M:%S)] pacman -U"
sudo pacman -U --noconfirm "$pkg"

# Drop the shadow install the old script left next to the package.
rm -f "$HOME/.local/bin/teams" \
  "$HOME/.local/share/applications/rusty-teams.desktop" \
  "$HOME/.local/share/icons/hicolor/256x256/apps/rusty-teams.png" \
  /usr/local/bin/rusty-teams \
  /usr/local/bin/teams
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
echo "[$(date +%H:%M:%S)] INSTALLED $(pacman -Q rusty-teams)"

if $restart; then
  nohup /usr/bin/teams >/tmp/rusty-teams-stdout.log 2>&1 &
  disown
  echo "[$(date +%H:%M:%S)] STARTED pid $! (log /tmp/rusty-teams-stdout.log)"
fi
