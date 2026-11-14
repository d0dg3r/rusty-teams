## Purpose

Give users a Help settings surface that builds a local, scrubbed support package and opens a browser-only GitHub issue draft so bug reports include client facts and developer-ready artifacts without automatic upload.

## ADDED Requirements

### Requirement: Help settings section

The settings dialog SHALL offer a Help section in the navigation, placed with About at the bottom of the nav (above or beside About), with UI strings available in English and German.

#### Scenario: User opens Help

- **WHEN** the user opens Settings and selects Help
- **THEN** the Help panel shows a short client summary (at least app version or build, OS, architecture, and UI language) and actions to create a support package, open a GitHub issue, copy the summary, and open the logs folder

### Requirement: Diagnostic and support paths

Diagnostic and support artifacts SHALL live under the OS local application data root for the product directory name `ms-teams-linux` (local, not roaming). Relative names under that root: `diagnostics.log`, `crash.log`, `call-dumps/`, `call-reports/`, `support-bundles/support-<UTC>/`.

#### Scenario: Linux local data root

- **WHEN** the app resolves diagnostic paths on Linux
- **THEN** the local data root is `~/.local/share/ms-teams-linux` (or the equivalent `directories` local data path for that name)

#### Scenario: macOS local data root

- **WHEN** the app resolves diagnostic paths on macOS
- **THEN** the local data root is `~/Library/Application Support/ms-teams-linux`

#### Scenario: Windows local data root

- **WHEN** the app resolves diagnostic paths on Windows
- **THEN** the local data root is `%LOCALAPPDATA%\ms-teams-linux`

### Requirement: Help shows diagnostic paths

Help SHALL show the absolute logs root and support-bundles root with a Copy-path control (clipboard receives only the path string; presented as a compact icon) and Open (system file manager) for each root. The client summary and issue draft SHALL include those absolute paths when known.

#### Scenario: Help shows paths

- **WHEN** the user opens Settings Help
- **THEN** the panel shows the absolute path to the logs root and to the support-bundles directory with a copy-path icon and Open actions

#### Scenario: User copies a root path

- **WHEN** the user activates Copy path on a Help path row
- **THEN** the clipboard contains that absolute path string only

### Requirement: Help lists and manages support packages

Help SHALL list support package folders under `support-bundles/` (newest first). Selecting a package SHALL expand to show its files. The user SHALL be able to delete a package folder from Help; the list refreshes afterward. An empty list SHALL show a short empty-state message. Deleting a package MUST NOT remove the app store, cookies, or tokens.

#### Scenario: User expands a support package

- **WHEN** the user selects a support package in Help
- **THEN** the panel shows the file names contained in that package folder

#### Scenario: User deletes a support package

- **WHEN** the user deletes a support package from Help
- **THEN** that folder is removed from disk and no longer appears in the list

#### Scenario: No support packages yet

- **WHEN** Help opens and `support-bundles/` has no packages
- **THEN** the panel shows an empty-state message

### Requirement: Help previews package files in-app

Selecting a file in an expanded support package SHALL open an in-app preview in Help. Markdown files (`.md`) SHALL render as Markdown; log and other text files SHALL show as plain monospace text. Help MUST NOT open the system file manager or an external editor for that file selection.

#### Scenario: User previews a Markdown package file

- **WHEN** the user selects a `.md` file in an expanded support package
- **THEN** Help shows that file’s content rendered as Markdown inside the settings Help panel

#### Scenario: User previews a log package file

- **WHEN** the user selects a `.log` file in an expanded support package
- **THEN** Help shows that file’s content as plain text inside the settings Help panel

### Requirement: Debug logging is off by default

Diagnostic file logging SHALL be disabled by default. The user SHALL be able to enable or disable it from Help without restarting, with the choice persisted in the app store. A CLI flag `--debug-log` or environment variable `RUSTY_TEAMS_DEBUG_LOG=1` SHALL enable logging from process start. Panic backtraces in `crash.log` SHALL always be recorded when a panic occurs, even when debug logging is off.

#### Scenario: Fresh install does not write diagnostics.log

- **WHEN** the app runs without prior opt-in and without `--debug-log` / `RUSTY_TEAMS_DEBUG_LOG`
- **THEN** the app does not append to `diagnostics.log`

#### Scenario: User enables debug logging in Help

- **WHEN** the user turns on Debug logging in Settings Help
- **THEN** subsequent diagnostic records are written to `diagnostics.log` and a client snapshot line is appended immediately

#### Scenario: User clears logs from Help

- **WHEN** the user chooses Clear logs in Help
- **THEN** rotated diagnostics and crash log files under the local data root and `call-dumps/` contents are removed

### Requirement: Diagnostic log ring rotation

While debug logging is enabled, `diagnostics.log` SHALL rotate by size into `diagnostics.log.1` and `diagnostics.log.2` (three files of at most 1 MiB each). Rotation MUST rename rather than truncate the active file in place. `crash.log` SHALL rotate into `crash.log.1` at 256 KiB (two files).

#### Scenario: Diagnostics log reaches 1 MiB

- **WHEN** `diagnostics.log` reaches 1 MiB and a new line is recorded
- **THEN** the previous content is preserved in a rotated sibling file and a new `diagnostics.log` receives the new line

### Requirement: Support package contents

Creating a support package SHALL write a new timestamped folder under `support-bundles/` in the local data root that contains `client.md` (English client summary including absolute paths and whether debug logging is on), a scrubbed merge of recent rotated `diagnostics.log` content when present, scrubbed `crash.log` content when present, up to the three most recent call-report Markdown files and their matching `.json` when present, a scrubbed recent call-dump `timeline.txt` as `last-call-timeline.log` when present, and a `README.md` that tells the user to attach those files to a GitHub issue and states that the store and tokens are not included.

#### Scenario: User creates a support package

- **WHEN** the user chooses Create support package
- **THEN** the app writes that folder and reveals it in the system file manager

#### Scenario: Sensitive values are scrubbed from the log copy

- **WHEN** the diagnostics log contains tokens, JWTs, emails, MRIs, thread ids, IP addresses, or ICE credentials
- **THEN** the copy written into the support package replaces those values with scrub placeholders and the live store, cookies, and token files are never copied into the package

#### Scenario: Call report JSON is included

- **WHEN** a recent call-report Markdown file has a matching `.json` beside it
- **THEN** the support package includes that JSON file as well

### Requirement: Client summary without identity secrets

The client summary (Help panel, `client.md`, clipboard copy, and issue body) SHALL include version or build, OS, architecture, desktop session when available, UI language, timezone, signed-in yes/no without email name or tenant, whether call reports are enabled, whether debug logging is enabled, and audio/camera device presence or selection labels that do not expose account secrets.

#### Scenario: User copies the summary

- **WHEN** the user chooses Copy summary
- **THEN** the clipboard receives the same English client block used for `client.md` and the issue draft

### Requirement: GitHub issue opens in the browser only

Opening a GitHub issue SHALL create a support package if needed, then open the system/external browser to a new-issue URL on `https://github.com/danieldaeschle/rusty-teams` with a short English title and body that include the client summary and the support package folder name. The app MUST NOT post the issue via API, MUST NOT upload attachments, and MUST NOT open the file manager automatically (a notice MAY offer Open folder).

#### Scenario: User opens a GitHub issue

- **WHEN** the user chooses Open GitHub issue
- **THEN** the browser opens a draft issue for `danieldaeschle/rusty-teams` and the support package remains local for the user to attach without a file-manager window opening by itself

### Requirement: Diagnostics start line and panic line

When debug logging is enabled (including at process start via flag or env), the app SHALL append an English client snapshot line after store and locale are known. When a panic occurs, the app SHALL write the panic to `crash.log` and, if debug logging is enabled, also append a short panic line to the diagnostics log.

#### Scenario: App starts with debug logging forced on

- **WHEN** the app starts with `--debug-log` or `RUSTY_TEAMS_DEBUG_LOG=1`
- **THEN** after store load the diagnostics log gains a client snapshot line with at least version or build and OS

#### Scenario: Panic with debug logging off

- **WHEN** the process panics while debug logging is disabled
- **THEN** `crash.log` contains the panic entry and `diagnostics.log` is not required to gain a new line