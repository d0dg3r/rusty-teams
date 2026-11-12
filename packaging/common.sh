# Gemeinsame Version-/Pfad-Helfer für packaging/*. Quelle: packaging/<fmt>/build_*.sh
# shellcheck shell=bash

packaging_root() {
  cd "$(dirname "${BASH_SOURCE[1]}")/../.." && pwd
}

# RELEASE_VERSION=0.3.0-joe.1 oder aus Git-Tag / Cargo.toml
packaging_version() {
  local root="$1"
  local ver="${RELEASE_VERSION:-}"
  if [[ -z "$ver" && -n "${GITHUB_REF_NAME:-}" && "${GITHUB_REF_NAME}" == v* ]]; then
    ver="${GITHUB_REF_NAME#v}"
  fi
  if [[ -z "$ver" ]]; then
    ver="$(
      awk '
        /^\[workspace\.package\]/ { in_pkg = 1; next }
        /^\[/ { in_pkg = 0 }
        in_pkg && /^version[[:space:]]*=/ {
          gsub(/"/, "", $3); print $3; exit
        }
      ' "$root/Cargo.toml"
    )"
  fi
  printf '%s\n' "$ver"
}

packaging_icon() {
  local root="$1"
  printf '%s\n' "$root/crates/app/assets/icon/teams-fast-256.png"
}

packaging_desktop() {
  local root="$1"
  printf '%s\n' "$root/crates/app/assets/linux/rusty-teams.desktop"
}

# Binary aus dem Release-Build (CI setzt BINARY_PATH)
packaging_binary() {
  local root="$1"
  if [[ -n "${BINARY_PATH:-}" && -x "${BINARY_PATH}" ]]; then
    printf '%s\n' "$BINARY_PATH"
    return
  fi
  if [[ -x "$root/target/release/teams" ]]; then
    printf '%s\n' "$root/target/release/teams"
    return
  fi
  echo "Missing release binary. Set BINARY_PATH or run: cargo build -p app --release" >&2
  return 1
}
