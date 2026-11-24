# Design

## Decision

Take upstream `main` as the shared product behaviour. Keep fork-only behaviour where upstream has no equivalent: Flatpak identity and update suppression, Forgejo as the CI and release host, CalDAV and ICS accounts already on the fork, and macOS Notification Center toasts.

## macOS updates

Upstream stopped swapping a fat Mach-O inside an `.app`. The fork had kept that path for in-app self-update. This sync follows upstream: the release asset is the `.app` zip only, and the update feed does not look for a macOS binary. The Forgejo macOS release job copies only the zip.

## ADR numbers

Upstream now uses ADR 0018 for regional format, 0019 for CalDAV keyring, 0020 for the macOS tray, 0021 for Linux packages, and 0022 for parking the idle Teams tab. The fork toast record moves to ADR 0023. Archived OpenSpec text may still say 0018; the ADR file states the rename.

## GitHub workflows

`build.yml` stays the Forgejo stub so the GitHub mirror does not compile releases. Upstream's packaging lint and Pages workflows are kept as they landed. They do not replace `.forgejo/workflows/`.

## Conflicts kept from the fork

- `self_update_allowed` returns false when `FLATPAK_ID` is set, including the unit test.
- Flatpak id and desktop-entry tests stay beside the new packaged-install tests.
- `notify-rust` stays a macOS dependency for Notification Center.
