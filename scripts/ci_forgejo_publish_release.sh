#!/usr/bin/env bash
# Create/update a Forgejo/Gitea release and upload asset files.
# Env:
#   GITHUB_TOKEN / FORGEJO_TOKEN  — required (Forgejo)
#   GITHUB_API_URL                — e.g. https://forgejo.lan/api/v1
#   GITHUB_REPOSITORY             — owner/repo
#   RELEASE_TAG                   — e.g. v1.1.40-beta.37
#   RELEASE_NAME                  — optional (default: tag)
#   RELEASE_PRERELEASE            — true|false
#   RELEASE_TARGET                — commit SHA
#   RELEASE_FILES                 — space-separated globs or paths
#   CHANGELOG_PATH                — optional (default: repo CHANGELOG.md)
#   RELEASE_BODY                  — optional override; otherwise CHANGELOG-Sektion zum Tag
#   GITHUB_MIRROR_TOKEN           — GitHub PAT; mirrors same assets to GitHub
#   GITHUB_MIRROR_REPO            — default d0dg3r/rusty-teams
#   GITHUB_MIRROR_API             — default https://api.github.com
#   GITHUB_MIRROR_UPLOADS         — default https://uploads.github.com
#   GITHUB_MIRROR_SKIP=1          — skip mirror (Notfall)
set -euo pipefail

token="${GITHUB_TOKEN:-${FORGEJO_TOKEN:-}}"
api="${GITHUB_API_URL:-}"
repo="${GITHUB_REPOSITORY:-}"
tag="${RELEASE_TAG:-}"
name="${RELEASE_NAME:-$tag}"
prerelease="${RELEASE_PRERELEASE:-false}"
target="${RELEASE_TARGET:-${GITHUB_SHA:-}}"
files_spec="${RELEASE_FILES:-}"

if [[ -z "$token" || -z "$api" || -z "$repo" || -z "$tag" || -z "$files_spec" ]]; then
  echo "Missing required env (token/api/repo/tag/files)" >&2
  exit 1
fi

api="${api%/}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${GITHUB_WORKSPACE:-$(cd "$SCRIPT_DIR/.." && pwd)}"
changelog_path="${CHANGELOG_PATH:-$ROOT/CHANGELOG.md}"
# Body immer als Datei (jq --rawfile) — Windows-Git-Bash zerlegt UTF-8 in
# Shell-Variablen (Umlaut/Sonderzeichen werden zu U+FFFD).
# Request-JSON ebenfalls als Datei (--data-binary @…): `curl -d "$json"` über
# die Windows-Kommandozeile kodiert Nicht-ASCII (·, ◀, Umlaute) zu ï¿½/? um.
notes_file="$(mktemp)"
payload_file="$(mktemp)"
cleanup_notes() { rm -f "$notes_file" "$payload_file"; }
trap cleanup_notes EXIT
if [[ -n "${RELEASE_BODY:-}" ]]; then
  printf '%s\n' "$RELEASE_BODY" >"$notes_file"
else
  "$SCRIPT_DIR/extract_changelog_section.sh" "$tag" "$changelog_path" "$notes_file"
fi
if [[ ! -s "$notes_file" ]]; then
  echo "Release body empty — CHANGELOG-Sektion für $tag fehlt (Gesetz: Release-Notes Pflicht)." >&2
  exit 1
fi

# curl flags: LAN CA oft fehlend → -k für forgejo.lan.
# Public ROOT_URL: AAAA geht zu Pangolin /auth (302) — curl -4 erzwingen
# (NODE_OPTIONS=ipv4first greift nur in Node/upload-artifact, nicht hier).
curl_opts=( -sS )
case "$api" in
  https://forgejo.lan/*|http://forgejo.lan/*)
    curl_opts+=( -k )
    echo "Using $api (TLS verify disabled — LAN CA may be missing)"
    ;;
  https://forgejo.devops-geek.net/*|http://forgejo.devops-geek.net/*)
    curl_opts+=( -4 )
    echo "Using $api with curl -4 (avoid Pangolin AAAA)"
    ;;
esac

api_curl() {
  curl "${curl_opts[@]}" "$@"
}

auth=( -H "Authorization: token ${token}" )

shopt -s nullglob
files=()
while IFS= read -r pattern; do
  [[ -z "$pattern" ]] && continue
  for f in $pattern; do
    [[ -f "$f" ]] || continue
    files+=("$f")
  done
done < <(printf '%s\n' "$files_spec")
if (( ${#files[@]} == 0 )); then
  echo "No files matched: $files_spec" >&2
  exit 1
fi

# Windows host runners: prefer explicit jq next to Git Bash PATH.
if ! command -v jq >/dev/null 2>&1; then
  for candidate in \
    /c/homelab/bin/jq.exe \
    /c/homelab/bin/jq \
    "$(cygpath -u 'C:\homelab\bin\jq.exe' 2>/dev/null || true)"; do
    if [[ -n "$candidate" && -x "$candidate" ]]; then
      export PATH="$(dirname "$candidate"):${PATH}"
      break
    fi
  done
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required for Forgejo release publish (install jq-windows-arm64.exe to C:\\homelab\\bin on win-02)" >&2
  exit 127
fi

echo "Publishing ${#files[@]} asset(s) to ${repo} @ ${tag}"

rel_json="$(api_curl "${auth[@]}" "${api}/repos/${repo}/releases/tags/${tag}" || true)"
rel_id="$(printf '%s' "$rel_json" | jq -r '.id // empty' 2>/dev/null || true)"

if [[ -z "$rel_id" ]]; then
  echo "Creating release ${tag}"
  jq -n \
    --arg tag "$tag" \
    --arg name "$name" \
    --arg target "$target" \
    --rawfile notes "$notes_file" \
    --argjson pre "$( [[ "$prerelease" == "true" ]] && echo true || echo false )" \
    '{tag_name:$tag, name:$name, body:$notes, target_commitish:$target, prerelease:$pre, draft:false}' \
    >"$payload_file"
  rel_json="$(api_curl "${auth[@]}" -H "Content-Type: application/json; charset=utf-8" \
    --data-binary @"$payload_file" "${api}/repos/${repo}/releases" || true)"
  rel_id="$(printf '%s' "$rel_json" | jq -r '.id // empty' 2>/dev/null || true)"
  # Create can fail if release exists but GET saw Pangolin HTML — re-fetch tag.
  if [[ -z "$rel_id" || "$rel_id" == "null" ]]; then
    rel_json="$(api_curl "${auth[@]}" "${api}/repos/${repo}/releases/tags/${tag}" || true)"
    rel_id="$(printf '%s' "$rel_json" | jq -r '.id // empty' 2>/dev/null || true)"
  fi
fi

if [[ -z "$rel_id" || "$rel_id" == "null" ]]; then
  echo "Failed to resolve release id:" >&2
  printf '%s\n' "$rel_json" >&2
  exit 1
fi
echo "release_id=$rel_id"

jq -n --rawfile notes "$notes_file" '{body:$notes}' >"$payload_file"
api_curl "${auth[@]}" -X PATCH -H "Content-Type: application/json; charset=utf-8" \
  --data-binary @"$payload_file" "${api}/repos/${repo}/releases/${rel_id}" \
  | jq -r '{id,tag_name,body_len:(.body|length)}'
echo "Release body synced from CHANGELOG ($tag)"

assets_json="$(api_curl "${auth[@]}" "${api}/repos/${repo}/releases/${rel_id}/assets")"

for f in "${files[@]}"; do
  base="$(basename "$f")"
  aid="$(printf '%s' "$assets_json" | jq -r --arg n "$base" '.[] | select(.name==$n) | .id' | head -1)"
  if [[ -n "$aid" && "$aid" != "null" ]]; then
    echo "Replacing existing asset $base (id=$aid)"
    # Forgejo/Gitea: DELETE …/releases/{id}/assets/{attachment_id} — der Pfad
    # ohne Release-ID liefert 404, der Upload danach erzeugt ein Duplikat.
    del_code="$(api_curl -X DELETE "${auth[@]}" -o /dev/null -w '%{http_code}' \
      "${api}/repos/${repo}/releases/${rel_id}/assets/${aid}" || true)"
    if [[ "$del_code" != 2* ]]; then
      echo "::warning::Asset $base (id=$aid) nicht gelöscht (HTTP ${del_code}) — Duplikat möglich."
    fi
  fi
  echo "Uploading $base ($(wc -c <"$f") bytes)"
  api_curl "${auth[@]}" \
    -H "Content-Type: application/octet-stream" \
    --data-binary @"$f" \
    "${api}/repos/${repo}/releases/${rel_id}/assets?name=$(printf '%s' "$base" | jq -sRr @uri)" \
    | jq -r '{name,size,browser_download_url}'
done

echo "Forgejo publish done."

# --- GitHub mirror (same local files, no rebuild) ---
mirror_github_assets() {
  local mirror_token="${GITHUB_MIRROR_TOKEN:-}"
  local mirror_repo="${GITHUB_MIRROR_REPO:-d0dg3r/rusty-teams}"
  local mirror_api="${GITHUB_MIRROR_API:-https://api.github.com}"
  local mirror_uploads="${GITHUB_MIRROR_UPLOADS:-https://uploads.github.com}"
  mirror_api="${mirror_api%/}"
  mirror_uploads="${mirror_uploads%/}"

  case "${GITHUB_MIRROR_SKIP:-}" in
    1|true|TRUE|yes|YES)
      echo "GITHUB_MIRROR_SKIP set — skipping GitHub asset mirror."
      return 0
      ;;
  esac

  if [[ -z "$mirror_token" ]]; then
    if [[ "${GITHUB_REF:-}" == refs/tags/v* ]]; then
      echo "::error::GITHUB_MIRROR_TOKEN fehlt — Tag-Publish muss Assets nach GitHub (${mirror_repo}) spiegeln."
      echo "::error::Forgejo-Secret GITHUB_MIRROR_TOKEN setzen (PAT contents:write auf ${mirror_repo}) oder GITHUB_MIRROR_SKIP=1."
      return 1
    fi
    echo "::warning::GITHUB_MIRROR_TOKEN leer — GitHub-Spiegel übersprungen (kein Tag-Push)."
    return 0
  fi

  echo "Mirroring ${#files[@]} asset(s) to GitHub ${mirror_repo} @ ${tag}"

  local gh_auth=(
    -H "Authorization: Bearer ${mirror_token}"
    -H "Accept: application/vnd.github+json"
    -H "X-GitHub-Api-Version: 2022-11-28"
  )
  local gh_json gh_id
  gh_json="$(curl -sS "${gh_auth[@]}" "${mirror_api}/repos/${mirror_repo}/releases/tags/${tag}" || true)"
  gh_id="$(printf '%s' "$gh_json" | jq -r '.id // empty' 2>/dev/null || true)"

  if [[ -z "$gh_id" || "$gh_id" == "null" ]]; then
    echo "Creating GitHub release ${tag}"
    jq -n \
      --arg tag "$tag" \
      --arg name "$name" \
      --arg target "$target" \
      --rawfile notes "$notes_file" \
      --argjson pre "$( [[ "$prerelease" == "true" ]] && echo true || echo false )" \
      '{tag_name:$tag, name:$name, body:$notes, target_commitish:$target, prerelease:$pre, draft:false}' \
      >"$payload_file"
    gh_json="$(curl -sS "${gh_auth[@]}" -H "Content-Type: application/json; charset=utf-8" \
      --data-binary @"$payload_file" "${mirror_api}/repos/${mirror_repo}/releases" || true)"
    gh_id="$(printf '%s' "$gh_json" | jq -r '.id // empty' 2>/dev/null || true)"
    if [[ -z "$gh_id" || "$gh_id" == "null" ]]; then
      # Race with .github/workflows/release.yaml notes job — re-fetch.
      gh_json="$(curl -sS "${gh_auth[@]}" "${mirror_api}/repos/${mirror_repo}/releases/tags/${tag}" || true)"
      gh_id="$(printf '%s' "$gh_json" | jq -r '.id // empty' 2>/dev/null || true)"
    fi
  fi

  if [[ -z "$gh_id" || "$gh_id" == "null" ]]; then
    echo "::error::GitHub release id für ${tag} nicht auflösbar:" >&2
    printf '%s\n' "$gh_json" >&2
    return 1
  fi
  echo "github_release_id=$gh_id"

  jq -n --rawfile notes "$notes_file" '{body:$notes}' >"$payload_file"
  curl -sS "${gh_auth[@]}" -X PATCH -H "Content-Type: application/json; charset=utf-8" \
    --data-binary @"$payload_file" "${mirror_api}/repos/${mirror_repo}/releases/${gh_id}" \
    | jq -r '{id,tag_name,body_len:(.body|length)}'
  echo "GitHub release body synced from CHANGELOG ($tag)"

  local gh_assets
  gh_assets="$(curl -sS "${gh_auth[@]}" "${mirror_api}/repos/${mirror_repo}/releases/${gh_id}/assets")"

  local f base aid del_code name_q
  for f in "${files[@]}"; do
    base="$(basename "$f")"
    aid="$(printf '%s' "$gh_assets" | jq -r --arg n "$base" '.[] | select(.name==$n) | .id' | head -1)"
    if [[ -n "$aid" && "$aid" != "null" ]]; then
      echo "Replacing existing GitHub asset $base (id=$aid)"
      # GitHub: DELETE /repos/{owner}/{repo}/releases/assets/{asset_id}
      del_code="$(curl -sS -X DELETE "${gh_auth[@]}" -o /dev/null -w '%{http_code}' \
        "${mirror_api}/repos/${mirror_repo}/releases/assets/${aid}" || true)"
      if [[ "$del_code" != 2* ]]; then
        echo "::warning::GitHub-Asset $base (id=$aid) nicht gelöscht (HTTP ${del_code}) — Duplikat möglich."
      fi
    fi
    name_q="$(printf '%s' "$base" | jq -sRr @uri)"
    echo "Uploading GitHub $base ($(wc -c <"$f") bytes)"
    curl -sS "${gh_auth[@]}" \
      -H "Content-Type: application/octet-stream" \
      --data-binary @"$f" \
      "${mirror_uploads}/repos/${mirror_repo}/releases/${gh_id}/assets?name=${name_q}" \
      | jq -r '{name,size,browser_download_url}'
  done

  echo "GitHub mirror done."
}

mirror_github_assets
