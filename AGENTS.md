# Agent notes — rusty-teams

## Fork vs Upstream

Pflicht-Workflow (Cursor Rule `.cursor/rules/fork-workflow.mdc`, `alwaysApply`):

- **`fork`** (`d0dg3r/rusty-teams`) = entwickeln, pushen, eigene Releases
- **`origin`** (`danieldaeschle/rusty-teams`) = Upstream; nur fetch + gezielte kleine PRs
- Nie Alltagskomits nach `origin` pushen
- Upstream-PRs: frischer Branch von `origin/main`, eine Scheibe Thema
- Fork-Releases: Tags wie `v0.3.0-joe.1` auf `fork`, nicht Upstream-`vX.Y.Z` spiegeln wenn der Inhalt abweicht

## OpenSpec

Produktverhalten liegt unter `openspec/` (Config: `openspec/config.yaml`). Skills: `/opsx-propose`, `/opsx-apply`, `/opsx-update`, `/opsx-archive`, `/opsx-sync`, `/opsx-explore`.

1. Beobachtbares Verhalten ändert sich → zuerst Change unter `openspec/changes/` (`/opsx-propose`).
2. Umsetzen mit `/opsx-apply`; Tasks abhaken inkl. Verify (`cargo test …`).
3. Nach Merge auf dem Fork: `/opsx-archive` (Deltas in `openspec/specs/`).
4. Bugfix ohne neues Verhalten, reines Refactoring/Tooling/Doku → `skip_specs: true` oder Cursor-Plan ohne Spec-Delta.

CLI: `/usr/local/bin/openspec` (Rule `openspec-cli-path`). Nicht «fehlt» melden ohne PATH-Check.
