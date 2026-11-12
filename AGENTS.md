# Agent notes — rusty-teams

## Forgejo SoT vs Upstream

Pflicht-Workflow (Cursor Rule `.cursor/rules/fork-workflow.mdc`, `alwaysApply`):

- **`origin`** (`forgejo.lan/devops-geek/rusty-teams`) = SoT; entwickeln, pushen, Tags, Releases
- **`github`** (`d0dg3r/rusty-teams`) = Offsite-Spiegel; Alltag nur lesen
- **`upstream`** (`danieldaeschle/rusty-teams`) = Upstream; nur fetch + gezielte kleine PRs
- Nie Alltagskomits nach `upstream` pushen
- Upstream-PRs: frischer Branch von `upstream/main`, eine Scheibe Thema
- Releases: Tags wie `v0.3.0-joe.1` auf Forgejo; GitHub bekommt dieselben Assets per Spiegel (`GITHUB_RELEASE.md`)

## OpenSpec

Produktverhalten liegt unter `openspec/` (Config: `openspec/config.yaml`). Skills: `/opsx-propose`, `/opsx-apply`, `/opsx-update`, `/opsx-archive`, `/opsx-sync`, `/opsx-explore`.

1. Beobachtbares Verhalten ändert sich → zuerst Change unter `openspec/changes/` (`/opsx-propose`).
2. Umsetzen mit `/opsx-apply`; Tasks abhaken inkl. Verify (`cargo test …`).
3. Nach Merge auf dem Fork: `/opsx-archive` (Deltas in `openspec/specs/`).
4. Bugfix ohne neues Verhalten, reines Refactoring/Tooling/Doku → `skip_specs: true` oder Cursor-Plan ohne Spec-Delta.

CLI: `/usr/local/bin/openspec` (Rule `openspec-cli-path`). Nicht «fehlt» melden ohne PATH-Check.
