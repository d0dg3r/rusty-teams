# Agent notes — rusty-teams

## Forgejo SoT vs Upstream

Required workflow (Cursor rule `.cursor/rules/fork-workflow.mdc`, `alwaysApply`):

- **`origin`** (`forgejo.lan/devops-geek/rusty-teams`) = SoT; develop, push, tags, releases
- **`github`** (`d0dg3r/rusty-teams`) = offsite mirror only. Never push, never open branches, never commit there. `git push github` is rejected by `.githooks/pre-push`
- **`upstream`** (`danieldaeschle/rusty-teams`) = fetch + thin PRs only. Never `git push upstream`
- Everyday commits and feature branches go to **`origin`** (Forgejo). Product branch is Forgejo **`main`** (OpenSpec, CI, releases). Install the hook once per clone: `scripts/install-git-hooks.sh`. Do not pass `--no-verify`
- Upstream visibility: weekday Forgejo job `.forgejo/workflows/upstream-watch.yaml` opens/updates one issue when Upstream `main` is ahead; it never merges. Local check: `scripts/upstream-status.sh`. Sync consciously: `git fetch upstream && git merge upstream/main` into `main`, then push `origin`. Do not invent a second everyday product branch only for Upstream sync
- Upstream PRs: branch from current `upstream/main`, one topic, **push the head to Forgejo first**, let the mirror copy it to GitHub, then `gh pr create` against `danieldaeschle/rusty-teams`. Before the PR leaves draft, fill the gate in [Before an upstream PR leaves draft](#before-an-upstream-pr-leaves-draft) without being asked (rule `.cursor/rules/upstream-pr-gate.mdc`)
- An `origin` push (including a merge to `main`) makes the Forgejo mirror **delete any GitHub branch that is not on Forgejo**, which closes the upstream PR (`head_ref_deleted`, actor often `d0dg3r`). The pre-push hook blocks that push until every open `d0dg3r` → upstream PR head exists on `origin`. Do not delete those heads while the PR is open. See `.cursor/rules/fork-workflow.mdc`
- Releases: tags like `v0.3.0-joe.1` on Forgejo; GitHub gets the same assets via mirror (`GITHUB_RELEASE.md`). A fork release contains the whole product line on `main`, including work that already has an open upstream PR. Commit that work onto `main` before tagging. Leave something out only when that release is explicitly an exception. Never delete a Forgejo branch that is the head of an open upstream PR; the next `origin` push would make the mirror delete it on GitHub and close the PR.
- Release notes are the `CHANGELOG.md` section for that tag (the publish script copies that section and nothing else). The section lists every user-visible change since the previous release, so the difference is visible in one place. Name that baseline. Do not point at an older tag instead of listing the changes. For `v0.6.1-joe.8` the baseline is `v0.6.1`.
- Local install: `scripts/install-linux-local.sh --restart` only. It builds with `TEAMS_GOOGLE_CLIENT_ID` (from `.env.google.local`) and installs that binary through pacman (`rusty-teams`). A bare `cargo build` + copy lacks the client id and drops every Google calendar. Do not leave a second binary in `~/.local/bin` or `/usr/local/bin`. The package always contains the full working tree, including uncommitted work. Leave something out only when that install is explicitly an exception.
## OpenSpec

Product behaviour lives under `openspec/` (config: `openspec/config.yaml`). Skills: `/opsx-propose`, `/opsx-apply`, `/opsx-update`, `/opsx-archive`, `/opsx-sync`, `/opsx-explore`.

**Language: English only** for all OpenSpec artifacts (proposal, design, tasks, specs, archives). Rule: `.cursor/rules/openspec-english.mdc` (`alwaysApply`). App UI may still offer German; that is product chrome, not OpenSpec authoring language.

**German product text uses Swiss conventions.** Rule: `.cursor/rules/schweizer-schreibweise.mdc` (`alwaysApply`). UI, docs, commits, and chat use `ss` (never `ß`), guillemets «…», `Europe/Zurich`, and Swiss number/date formats. OpenSpec stays English.

**OpenSpec first (no exceptions).** Rule: `.cursor/rules/openspec-first.mdc` (`alwaysApply`). Every plan for observable behaviour starts with an OpenSpec change under `openspec/changes/` before code, smoke, or Roadmap Done. A Cursor plan does not replace the change. Smoke-only or «already coded» does not skip it. Only pure refactoring, tooling, or docs with no behaviour change may use `skip_specs: true`.

1. Observable behaviour changes → first a change under `openspec/changes/` (`/opsx-propose`).
2. Implement with `/opsx-apply`; check off tasks including verify (`cargo test …`).
3. After merge on the fork: `/opsx-archive` (deltas into `openspec/specs/`).
4. Bugfix with no new behaviour, pure refactoring/tooling/docs → `skip_specs: true`.

CLI: `/usr/local/bin/openspec` (rule `openspec-cli-path`). Do not report «missing» without a PATH check.

## UI look and shell

Chrome, islands, spacing, radii, type, and colour roles: `docs/design/islands/SPEC.md` (rule `ui-spec`, `GUARDRAILS.md` Look). Feature OpenSpecs describe content and behaviour on those surfaces; they do not invent look tokens.

## Before an upstream PR leaves draft

This applies only when opening or updating a pull request against `danieldaeschle/rusty-teams`. Forgejo everyday work does not use this template. Do it without being asked, while the PR is still a draft. `gate: no visual` and `gate: skip` are maintainer-only.

The body follows the upstream template: `## Summary`, `## Problem`, `## AI model`, `## Tests`, `## Review`, `## Screenshot`. The check is upstream `CONTRIBUTING.md` («When a PR is ready for review») and `.github/scripts/pr_gate.py`. Planning stays on Forgejo: the upstream diff must not contain `openspec/`, `.specify/`, or `.kiro/`.

- **Title:** `type(scope): message` from the user's point of view. Type is one of `feat`, `fix`, `perf`, `refactor`, `docs`, `test`, `chore`, `ci`, `build`. Lowercase scope, no emoji.
- **Review:** two independent reviews of `git diff upstream/main...HEAD`. Each reviewer must not have written the change (a fresh session or a subagent). Then `## Review` with at least two non-empty lines: one line per review (what ran it), then one line per finding (fixed, or not fixed and why). An empty Review section fails the gate.
- **Problem:** without `Closes` / `Fixes` / `Resolves` plus `#n` or an issue URL on `danieldaeschle/rusty-teams`, write `## Problem` (at least 80 characters): what is wrong or missing, when a user hits it (steps or when/then), and what should happen instead.
- **Issue first:** a `feat` PR, or more than 400 changed lines (lockfiles do not count), needs an issue labelled `status: accepted`. A maintainer sets that label. Do not add it yourself, do not mark the PR ready, and tell the user — or split the change. Write `Closes #123` only when that issue exists.
- **Screenshot:** a diff under `crates/app/src/views/`, `settings/`, `components/`, `widgets/`, `crates/app/src/*_view.rs`, or `locales/` needs an image in the body, taken with `cargo run -p app -- --demo` or `scripts/headless-shot.sh`. Otherwise tick exactly `- [x] No visible change` and say why. No real Teams account data.
- **Tests:** what ran and what did not. If the diff touches Windows-only code (`cfg(windows)` or a Windows path), say whether it was built on Windows.
- **Scope:** a `vendor/` change says why in the body. At most 5 open upstream PRs, drafts included.
