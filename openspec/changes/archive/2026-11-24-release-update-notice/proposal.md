# Proposal

## Why

Replacing the running binary from inside the app fights the live process (file locks, the database, the single-instance lock, virus scanners) and breaks more often than it helps. A release build only needs to say a newer release exists and open that release page.

## What Changes

- **BREAKING** for anyone who relied on in-app download and restart: the app no longer downloads a release asset, stages it beside the executable, or swaps the running binary.
- A release-tagged build on Windows, Linux, and macOS shows one dialog when a newer GitHub release exists. One action opens that release's page in the browser. "Not now" hides that version until the next start.
- The same check and the same settings switch exist on every OS. The switch is on unless the user turns it off. There is no Linux-only key and no "only the XDG copy may update" gate.
- Dev builds without a release tag stay quiet. Flatpak still does not check GitHub or offer the dialog (the package owns updates).
- The Linux first-start install into the application menu stays. It is not an update.

## Capabilities

### New Capabilities

- `release-update-notice`: Tell a release build that a newer GitHub release exists and open that release page. Do not download or replace the running binary.

### Modified Capabilities

- `linux-flatpak`: Flatpak still must not download a GitHub binary or offer a GitHub update, including the new release-page dialog and its settings switch.

## Impact

- Update check, dialog, and settings on Windows, Linux, and macOS.
- Removal of the quiet Windows download, the idle restart, and the Linux download-then-restart path.
- Locales, README, roadmap, and the update half of the Linux self-update decision record.
- Flatpak behaviour stays "packaging owns updates"; the requirement text must name the dialog so the new notice cannot appear there.
