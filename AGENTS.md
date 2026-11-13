# Agent notes — rusty-teams

## Forgejo SoT vs Upstream

Required workflow (Cursor rule `.cursor/rules/fork-workflow.mdc`, `alwaysApply`):

- **`origin`** (`forgejo.lan/devops-geek/rusty-teams`) = SoT; develop, push, tags, releases
- **`github`** (`d0dg3r/rusty-teams`) = offsite mirror; everyday read-only
- **`upstream`** (`danieldaeschle/rusty-teams`) = Upstream; fetch + thin targeted PRs only
- Never push everyday commits to `upstream`
- Upstream PRs: fresh branch from `upstream/main`, one topic slice
- Releases: tags like `v0.3.0-joe.1` on Forgejo; GitHub gets the same assets via mirror (`GITHUB_RELEASE.md`)
## OpenSpec

Product behaviour lives under `openspec/` (config: `openspec/config.yaml`). Skills: `/opsx-propose`, `/opsx-apply`, `/opsx-update`, `/opsx-archive`, `/opsx-sync`, `/opsx-explore`.

**Language: English only** for all OpenSpec artifacts (proposal, design, tasks, specs, archives). Rule: `.cursor/rules/openspec-english.mdc` (`alwaysApply`). App UI may still offer German; that is product chrome, not OpenSpec authoring language.

1. Observable behaviour changes → first a change under `openspec/changes/` (`/opsx-propose`).
2. Implement with `/opsx-apply`; check off tasks including verify (`cargo test …`).
3. After merge on the fork: `/opsx-archive` (deltas into `openspec/specs/`).
4. Bugfix with no new behaviour, pure refactoring/tooling/docs → `skip_specs: true` or a Cursor plan without a spec delta.

CLI: `/usr/local/bin/openspec` (rule `openspec-cli-path`). Do not report «missing» without a PATH check.

## UI look and shell

Chrome, islands, spacing, radii, type, and colour roles: `docs/design/islands/SPEC.md` (rule `ui-spec`, `GUARDRAILS.md` Look). Feature OpenSpecs describe content and behaviour on those surfaces; they do not invent look tokens.
