# Proposal

## Why

Upstream `main` is 61 commits ahead of Forgejo `main` (through `8a5c5082`, release 0.5.0 and the fixes after it). The fork has to take that behaviour in without dropping Flatpak packaging, Forgejo CI, CalDAV accounts, or macOS Notification Center toasts.

## What Changes

- Merge `upstream/main` into Forgejo `main`.
- macOS no longer offers an in-app Mach-O self-update. The published artifact stays the universal `.app` zip. Users replace the app bundle.
- Flatpak still refuses XDG self-install and GitHub self-update.
- GitHub `build.yml` stays a stub. Compile and release stay on Forgejo.
- Renumber the fork macOS Notification Center decision from ADR 0018 to ADR 0023, because upstream shipped regional format as ADR 0018.

## Capabilities

### New Capabilities

- `macos-self-update`: macOS does not replace its own binary from a release asset.

### Modified Capabilities

None. Flatpak requirements stay as already specified. This sync only keeps that behaviour while taking upstream `main`.

## Impact

- Merge of `upstream/main` (people outside the home tenant, chat layout fixes, Linux packages, regional format, idle-tab parking, tray icon choice, and the 0.5.0 release notes already reviewed upstream).
- `scripts/build-macos.sh` and `.forgejo/workflows/release-macos.yaml` stop publishing a bare `*-macos-universal` Mach-O.
- Docs: `README.md`, `ROADMAP.md`, `docs/macos-smoke.md`, `docs/decisions/0023-macos-desktop-toasts-use-notification-center.md`.

## Out of scope

- Pushing the merge to Forgejo.
- Closing or retargeting open upstream pull requests.
