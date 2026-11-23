#!/usr/bin/env bash
# Release Linux binary with TEAMS_GOOGLE_* baked in, install to ~/.local + desktop entry,
# and to /usr/local/bin/rusty-teams when that install exists.
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

if $restart; then
  # Binary is installed as rusty-teams (/usr/local) and teams (~/.local); kill both.
  pkill -x rusty-teams 2>/dev/null || true
  pkill -x teams 2>/dev/null || true
  sleep 1
  # Stale single-instance socket keeps a deleted-exe process as primary.
  rm -f "${XDG_RUNTIME_DIR:-/tmp}/rusty-teams-${USER}.sock"
fi

mkdir -p "$HOME/.local/bin" \
  "$HOME/.local/share/applications" \
  "$HOME/.local/share/icons/hicolor/256x256/apps"
install -m 755 "$BIN" "$HOME/.local/bin/teams"
install -m 644 "$repoRoot/crates/app/assets/icon/teams-fast-256.png" \
  "$HOME/.local/share/icons/hicolor/256x256/apps/rusty-teams.png"

# Absolute Exec so Dock/menu launch still finds the binary.
sed "s|^Exec=.*|Exec=$HOME/.local/bin/teams|" \
  "$repoRoot/packaging/linux/rusty-teams.desktop" \
  > "$HOME/.local/share/applications/rusty-teams.desktop"
chmod 644 "$HOME/.local/share/applications/rusty-teams.desktop"
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" 2>/dev/null || true
echo "[$(date +%H:%M:%S)] INSTALLED $HOME/.local/bin/teams"

if [ -e /usr/local/bin/rusty-teams ]; then
  sudo install -m 755 "$BIN" /usr/local/bin/rusty-teams
  echo "[$(date +%H:%M:%S)] INSTALLED /usr/local/bin/rusty-teams"
fi

echo "[$(date +%H:%M:%S)] VERIFY ok: client id and secret prefix present in binary"

if $restart; then
  nohup "$HOME/.local/bin/teams" >/tmp/rusty-teams-stdout.log 2>&1 &
  disown
  echo "[$(date +%H:%M:%S)] STARTED pid $! (log /tmp/rusty-teams-stdout.log)"
fi
