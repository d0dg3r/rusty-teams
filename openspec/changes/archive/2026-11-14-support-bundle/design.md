# Design

## Context

See proposal.md — Why. Today `app_base::diagnostics` appends lines to `diagnostics.log` (1 MB rotate). Call reports already scrub and save under `call-reports/`. Settings About only shows version/build. Help must reuse those paths and the existing scrubber without inventing a new shell surface (`docs/design/islands/SPEC.md` Dialog only).

Path and issue-target choices are recorded in ADR 0012 (`docs/decisions/0012-local-diagnostic-data-and-upstream-issues.md`).

## Goals / Non-Goals

**Goals:**

- Testable support-bundle builder (files only) that Help wires to.
- Scrub diagnostics before shipping a copy; never include store/cookies/tokens.
- Browser-only issue draft to upstream `danieldaeschle/rusty-teams` with a short URL body.
- Startup client line + panic hook into the same diagnostics log.
- One path API for the local data root and relative layout; Help shows absolute paths.

**Non-Goals:**

- Zip crate / automatic upload / GitHub API.
- Issues against the fork mirror `d0dg3r/rusty-teams` (Issues disabled there).
- Renaming `ms-teams-linux` or migrating the store from `data_dir` (Roaming on Windows) to `data_local_dir`.
- Live WebRTC internals overlay.
- Moving the call-report toggle out of Devices.

## Decisions

1. **Module home: `app-base` (+ thin app/state glue)**  
   `ClientInfo` + path helpers in `app-base`; `write_support_bundle` in `app-state` so it can call the call-report scrubber without a dependency cycle.

2. **Local data root and layout**  
   All diagnostic/support artifacts use `ProjectDirs::from("", "", "ms-teams-linux").data_local_dir()`:

   | OS | Root |
   |----|------|
   | Linux | `~/.local/share/ms-teams-linux` |
   | macOS | `~/Library/Application Support/ms-teams-linux` |
   | Windows | `%LOCALAPPDATA%\ms-teams-linux` |

   Relatives: `diagnostics.log`, `crash.log`, `call-dumps/`, `call-reports/`, `support-bundles/support-<utc>/`.

3. **Bundle layout**  
   `{local}/support-bundles/support-<utc>/` with `client.md`, scrubbed `diagnostics.log`, last 3 call-report `*.md`, `README.md`. Folder is the artifact (no zip). `client.md` includes absolute paths.

4. **Issue URL**  
   `https://github.com/danieldaeschle/rusty-teams/issues/new?title=…&body=…`. Do not auto-reveal the file manager; notice may offer Open folder.

5. **Help UI**  
   `SettingsSection::Help` as an Entity view (like Devices): client summary; path rows with copy-path icon + Open; debug-logging toggle (default off) + clear logs; list of `support-bundles/*` (newest first) with expand-to-files, in-app file preview (`.md` via `Draft::from_markdown` → `to_html` → `render_blocks`; `.log`/`.json`/`.txt` as mono), and delete; Create/Issue/summary actions. Locales DE/EN. List/delete helpers live in `app-base::support` for unit tests.

6. **Panic hook**  
   `crash_log::install` always writes panics (rotated). When debug logging is on, a short panic line is also appended to `diagnostics.log`.

7. **Debug logging gate and rotation**  
   Store meta `diagnostics_enabled` (default off) + AtomicBool; CLI/env override. Ring files for diagnostics (3×1 MiB) and crash (2×256 KiB). App crates’ `log::` output and high-signal notices/call lifecycle lines feed the diagnostics file only when enabled.

## Risks / Trade-offs

- **[Risk] Dependency cycle if `app-base` imports call-model scrub** → Scrub stays in `app-state`.
- **[Risk] Long issue URL truncated by OS** → Short English body; full log in the folder.
- **[Trade-off] Keep `ms-teams-linux` name** → Avoids breaking existing installs; name is misleading on macOS/Windows but stable.
- **[Trade-off] Store may stay on Roaming on Windows** → Out of scope; Help/paths document the local root for diagnostics only.

## Migration Plan

No data migration. Existing files under the local root keep working. Ship with normal release; Help shows paths after update.

## Open Questions

None.
