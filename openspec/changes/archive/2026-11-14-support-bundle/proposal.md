# Proposal

## Why

Users who hit a bug today have only a raw `diagnostics.log` and optional call reports with no guided place to collect client facts or open a GitHub issue. Developers then ask for version, OS, session type, and logs that the app already knows. A Help surface plus a local support bundle closes that gap without sending data automatically.

## What Changes

- Add a **Help** settings section (above About) with a short client summary, absolute log/bundle paths, and actions to create a support bundle, open a pre-filled GitHub issue, copy the summary, and reveal the logs folder.
- Add a **debug / support engine** that writes a timestamped folder under the OS **local** data root (`ms-teams-linux`): scrubbed diagnostics log, last call-report Markdown files, a `client.md` block (with absolute paths), and a short README. No store, cookies, or tokens.
- Document the OS path layout in OpenSpec and ADR 0012; track all of `docs/` in git (drop the `docs/*` ignore).
- On app start, record a one-line client snapshot in the diagnostics log; on panic, append the panic message to the same log before exit.
- Opening an issue only opens the browser to upstream `danieldaeschle/rusty-teams` with a short English body; the user attaches the bundle folder contents. No GitHub API upload. The fork mirror (`d0dg3r/rusty-teams`) has Issues disabled.
- Optional issue form YAML may live under `.github/ISSUE_TEMPLATE/` for structured fields when used.

## Capabilities

### New Capabilities

- `support-bundle`: Local support-package creation, scrubbing, Help settings actions, and browser-only GitHub issue draft for bug reports.

### Modified Capabilities

- (none)

## Impact

- Settings nav / dialog (`SettingsSection`), About stays as version/build only.
- Diagnostics install path and call-report storage used as inputs to the bundle.
- Existing call-report scrubber reused for the diagnostics log copy.
- Locales DE/EN for Help strings.
- Repo: ADR 0012, `.github/ISSUE_TEMPLATE/bug_report.yml` on the Forgejo SoT (mirrored to GitHub).
