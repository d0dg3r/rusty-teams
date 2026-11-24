## Context

Forgejo `main` is the product SoT (OpenSpec, CI, releases). Upstream `danieldaeschle/rusty-teams` is currently fully contained in `origin/main`; the operational gap is noticing when Upstream advances. A separate `development` product branch was rejected: merge conflicts stay the same size and remotes/CI/docs would all move.

## Goals / Non-Goals

**Goals:**

- Weekday signal when Upstream `main` is ahead of Forgejo `main`
- One open Forgejo issue with a commit list; update that issue instead of opening duplicates
- Local script with the same comparison for on-demand use
- Document that sync is a conscious `git merge upstream/main` into `main`

**Non-Goals:**

- Auto-merge or auto-rebase of Upstream into the product branch
- A second everyday product branch (`development`)
- Changes under `crates/`
- Pushing to `github` or `upstream`

## Decisions

1. **Compare SHAs via shallow fetch in CI.** The watch checks out Forgejo `main`, adds Upstream as a remote, fetches `main`, then uses `git rev-list --count HEAD..upstream/main` and `git log --format=…`. No third-party GitHub API dependency beyond clone/fetch.

2. **Issue identity by title marker.** Open issues whose title starts with a fixed prefix (e.g. `Upstream ahead:`) are reused. If none exist, create one; if one exists, replace the body with the fresh commit list. If several exist (manual mistake), update the newest and leave a note — prefer creating at most one from the watch.

3. **Schedule: weekdays only.** `schedule` cron on Forgejo Actions (e.g. `0 8 * * 1-5` Europe/Zurich-ish UTC `0 7 * * 1-5`) plus `workflow_dispatch` for manual runs.

4. **Permissions.** The job needs `issues: write` on the Forgejo repo (default `GITHUB_TOKEN` / Forgejo Actions token for the same repo).

5. **Local script.** `scripts/upstream-status.sh` fetches `upstream` (or uses existing refs), compares against `origin/main` when available else `main`, prints sync status or commit list, exit 0 when comparison succeeds (ahead or not). Exit non-zero only on fetch/compare failure.

6. **Docs.** Short section in `.cursor/rules/fork-workflow.mdc` and `AGENTS.md`: watch exists; merge consciously; do not invent a second product branch for Upstream visibility.

## Risks / Trade-offs

- **Forgejo schedule reliability** — runners may delay cron; `workflow_dispatch` covers gaps.
- **Issue spam** — mitigated by single-issue reuse.
- **Stale issue after merge** — human closes the issue after syncing; the next watch creates a new one only when ahead again. Optional later: auto-close when in sync (out of scope for v1 unless trivial).

## Migration Plan

1. Land OpenSpec delta, workflow, script, and docs on a branch; merge to `main`.
2. Manually dispatch the workflow once to verify “in sync” quiet exit.
3. After the next Upstream commit, confirm one issue appears.

## Open Questions

None for v1. Auto-close when back in sync can be a follow-up if closing by hand is annoying.
