# Design

## Context

See proposal.md for why the in-app swap goes away. Today Windows quietly downloads a GitHub asset and restarts when idle (`crates/app/src/views/shell.rs`). Linux asks, then downloads and swaps (`crates/app/src/linux_update.rs`) only for the copy under `~/.local/share/rusty-teams`. The feed reads `danieldaeschle/rusty-teams` (`crates/app-base/src/release_feed.rs`). This product line publishes from Forgejo and mirrors the same assets to `d0dg3r/rusty-teams` (`GITHUB_RELEASE.md`). Flatpak already refuses a GitHub self-update (`openspec/specs/linux-flatpak/spec.md`).

## Goals / Non-Goals

**Goals:**

- One dialog on Windows, Linux, and macOS for release-tagged builds.
- Primary action opens the public release page for that tag.
- Delete download, stage, and binary swap. Keep the Windows fast quit (`exit_now`), which is not an update.
- One settings meta key, `updates.enabled`, default on. Do not read `linux.updates.enabled`.

**Non-Goals:**

- Linux menu install (`crates/app/src/linux_install.rs`) stays.
- Flatpak, and any other packaged Linux build that already skips self-install, does not get the dialog.
- No Windows ARM64 asset-suffix work from `pr/release-assets`.

## Decisions

1. **Public page is the GitHub mirror, not upstream.** The check and the opened URL use `https://github.com/d0dg3r/rusty-teams`. The page for a tag is `.../releases/tag/<tag>`. Forgejo is the binary SoT but is not a public URL. Upstream `danieldaeschle/rusty-teams` is a different product line. Alternative considered: keep the upstream feed. Rejected because a fork build would announce upstream versions.

2. **A newer release is enough.** The check compares release tags and ignores whether an asset for this OS is attached. The page lists the files. Alternative considered: keep the platform asset suffix. Rejected because macOS would stay silent and the app no longer installs an asset.

3. **Same module on every OS.** Generalize the Linux dialog so `main` starts it for any non-demo release build that is not Flatpak. Settings rows for the switch and Check now are not inside the Linux-only install section.

4. **Relaunch env stays.** `RELAUNCH_ENV` is how install, org switch, and the sign-in browser restart tell the new process to wait. Only the update swap, idle poll, title-bar restart, and old-binary cleanup go away.

## Risks / Trade-offs

- [Users who expected a silent Windows restart must install the new build themselves] → The dialog names both versions and opens the release.
- [A Linux user who turned updates off under `linux.updates.enabled` sees the check on again] → One shared key, as requested. No migration.
- [The mirror can lag Forgejo] → The dialog waits until the GitHub release list shows the tag. The page is the same place the user downloads from.

## Migration Plan

Ship in the next fork release. No data migration. Rollback is reverting the commit; old builds that still swap are unchanged until the user replaces them.

## Open Questions

None.
