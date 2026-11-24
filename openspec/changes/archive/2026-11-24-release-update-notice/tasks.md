# Tasks

## 1. Feed

- [x] 1.1 Point the release list and the release-page URL at `d0dg3r/rusty-teams`, and treat a newer tag as enough without a platform asset. Verify with `cargo test -p app-base --lib release_feed`.

## 2. Notice

- [x] 2.1 Remove download, staging, binary swap, idle restart, and the title-bar restart control. Keep Windows fast quit and `RELAUNCH_ENV` for the other restarts. Verify with `cargo test -p app-base --lib updater`.
- [x] 2.2 Show one dialog on Windows, Linux, and macOS for release-tagged builds: Not now, or open the release page. Use meta key `updates.enabled` (default on) and the same Settings rows on every OS. Flatpak gets neither the dialog nor those rows. Verify with `cargo test -p app --lib linux_update` if tests exist, otherwise by the dialog module compiling in `cargo test -p app --lib`.

## 3. Docs

- [x] 3.1 Update locales, README, roadmap, and add an ADR that replaces the self-update half of ADR 0014. Verify the strings no longer tell the user a download or restart will install the update.

## Workflow follow-up

- Archive this change into `openspec/specs/` after it lands on `main`.
