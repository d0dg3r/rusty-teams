# Design

## Context

`scripts/ci_forgejo_publish_release.sh` uploads whatever `RELEASE_FILES` expands to, then mirrors that same list to GitHub. Linux, Windows, and macOS each call it with their own list. A single `SHA256SUMS` for the whole release would be replaced by the next job.

## Goals / Non-Goals

**Goals:**

- One `<package>.sha256` next to each package, uploaded and mirrored.
- The line is `sha256sum -c` compatible.
- Linux runners use `sha256sum`. macOS runners use `shasum -a 256` when `sha256sum` is absent.

**Non-Goals:**

- A signature, a combined sums file, or rewriting the tag that is already building.
- Checksumming the sidecar itself.

## Decisions

1. Build the sidecar inside the publish script after the file list is collected, and append it to the list that both Forgejo and the GitHub mirror upload. Workflows stay unchanged. A glob such as `dist/*.exe` still gets a checksum because the sidecar is added after expansion.
2. The sidecar sits beside the package (`dist/name.zip.sha256`) and names the base name, so `sha256sum -c` is run from `dist/`.

## Risks / Trade-offs

- A runner with neither `sha256sum` nor `shasum` fails the publish. Both tools exist on the Linux and macOS runners used here. Windows Git Bash provides one of them.

## Migration Plan

The next tag publishes the sidecars. Already published tags are left as they are.

## Open Questions

None.
