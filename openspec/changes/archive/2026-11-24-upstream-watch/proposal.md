## Why

Everyday work and releases already live on Forgejo `main`, but Upstream movement is invisible until someone runs `git fetch upstream` by hand. The fork is currently fully caught up with `danieldaeschle/rusty-teams`; the gap is the missing signal when Upstream advances again. A second product branch would not shrink merge conflicts and would double the workflow.

## What Changes

- Add a weekday Forgejo watch that compares Upstream `main` to Forgejo `main` and opens or updates a single issue when Upstream is ahead
- Add a local `scripts/upstream-status.sh` for the same comparison on demand
- Document that product work stays on `main` and Upstream sync remains a conscious merge after the notice
- The watch never merges Upstream into the product branch

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `fork-delivery`: Upstream movement MUST be reported when Upstream `main` is ahead of Forgejo `main`; everyday development and releases stay on Forgejo `main`; the watch MUST NOT auto-merge

## Impact

- New Forgejo workflow under `.forgejo/workflows/`
- New local script `scripts/upstream-status.sh`
- Agent/docs updates in `.cursor/rules/fork-workflow.mdc` and `AGENTS.md`
- No changes under `crates/`
