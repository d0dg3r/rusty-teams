#!/usr/bin/env bash
# Release Linux binary with TEAMS_GOOGLE_* baked in, install to ~/.local + desktop entry.
# Usage: source .env.google.local && scripts/install-linux-local.sh
# Or: build first with env set, then this script copies target/release/teams.
set -euo pipefail
repoRoot="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repoRoot"
export PATH="/usr/bin:/bin:/usr/local/bin:/usr/sbin:/sbin:$HOME/.cargo/bin:$PATH"

if [ -z "${TEAMS_GOOGLE_CLIENT_ID:-}" ] && [ -f "$repoRoot/.env.google.local" ]; then
  set -a
  # shellcheck disable=SC1091
  source "$repoRoot/.env.google.local"
  set +a
fi

BIN="$repoRoot/target/release/teams"
if [ ! -x "$BIN" ]; then
  if [ -z "${TEAMS_GOOGLE_CLIENT_ID:-}" ]; then
    echo "TEAMS_GOOGLE_CLIENT_ID missing and no binary at $BIN" >&2
    exit 1
  fi
  echo "[$(date +%H:%M:%S)] building release…"
  cargo build -p app --release --bin teams
fi

if ! grep -aFq "apps.googleusercontent.com" "$BIN"; then
  echo "client id not in binary — rebuild with TEAMS_GOOGLE_CLIENT_ID set" >&2
  exit 1
fi

mkdir -p "$HOME/.local/bin" \
  "$HOME/.local/share/applications" \
  "$HOME/.local/share/icons/hicolor/256x256/apps"
install -m 755 "$BIN" "$HOME/.local/bin/teams"
install -m 644 "$repoRoot/crates/app/assets/icon/teams-fast-256.png" \
  "$HOME/.local/share/icons/hicolor/256x256/apps/rusty-teams.png"

# Absolute Exec so Dock/menu launch still finds the binary.
sed "s|^Exec=.*|Exec=$HOME/.local/bin/teams|" \
  "$repoRoot/crates/app/assets/linux/rusty-teams.desktop" \
  > "$HOME/.local/share/applications/rusty-teams.desktop"
chmod 644 "$HOME/.local/share/applications/rusty-teams.desktop"
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" 2>/dev/null || true

echo "[$(date +%H:%M:%S)] INSTALLED $HOME/.local/bin/teams"
echo "[$(date +%H:%M:%S)] VERIFY ok: client id present in binary"
ls -la "$HOME/.local/bin/teams"
