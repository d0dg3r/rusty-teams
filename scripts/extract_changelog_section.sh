#!/usr/bin/env bash
# Extrahiert genau eine CHANGELOG-Sektion für ein Release-Tag.
#
# Aufruf:
#   ./scripts/extract_changelog_section.sh v1.1.40-beta.45
#   ./scripts/extract_changelog_section.sh 1.1.40-beta.45 CHANGELOG.md RELEASE_NOTES.md
#
# Fehlt die Sektion in CHANGELOG.md, wird CHANGELOG_ARCHIVE.md (1.x) versucht.
# Exit 2 wenn die Sektion in beiden Dateien fehlt (kein stilles Fallback auf den ganzen Changelog).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
raw="${1:-}"
changelog="${2:-$ROOT/CHANGELOG.md}"
out="${3:-}"

if [[ -z "$raw" ]]; then
  echo "usage: $0 <version|vX.Y.Z> [CHANGELOG.md] [outfile]" >&2
  exit 1
fi

ver="${raw#v}"
if [[ ! -f "$changelog" ]]; then
  echo "extract_changelog_section: $changelog fehlt." >&2
  exit 1
fi

notes="$(
  awk -v ver="$ver" '
    BEGIN { in_section = 0 }
    /^## \[/ {
      if (in_section) { exit }
      if ($0 ~ "^## \\[" ver "\\]") { in_section = 1; print; next }
    }
    in_section { print }
  ' "$changelog"
)"

if [[ -z "${notes//[$'\t\n\r ']/}" ]]; then
  archive="$(dirname "$changelog")/CHANGELOG_ARCHIVE.md"
  if [[ "$(basename "$changelog")" == "CHANGELOG.md" && -f "$archive" ]]; then
    notes="$(
      awk -v ver="$ver" '
        BEGIN { in_section = 0 }
        /^## \[/ {
          if (in_section) { exit }
          if ($0 ~ "^## \\[" ver "\\]") { in_section = 1; print; next }
        }
        in_section { print }
      ' "$archive"
    )"
  fi
fi

if [[ -z "${notes//[$'\t\n\r ']/}" ]]; then
  echo "extract_changelog_section: keine Sektion '## [$ver]' in $changelog" >&2
  exit 2
fi

if [[ -n "$out" ]]; then
  printf '%s\n' "$notes" >"$out"
else
  printf '%s\n' "$notes"
fi
