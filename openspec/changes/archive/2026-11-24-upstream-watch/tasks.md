## 1. Spec and docs contract

- [x] 1.1 Merge the `fork-delivery` delta into `openspec/specs/fork-delivery/spec.md` (or keep it as the active change delta until archive; implementation may proceed against the change delta)
- [x] 1.2 Update `.cursor/rules/fork-workflow.mdc` with Upstream watch + conscious merge on `main`
- [x] 1.3 Update `AGENTS.md` with the same short Upstream-watch note

## 2. Local status script

- [x] 2.1 Add `scripts/upstream-status.sh` that fetches Upstream and reports in-sync or the ahead commit list
- [x] 2.2 Make the script executable and verify it runs against the current remotes

## 3. Forgejo watch workflow

- [x] 3.1 Add `.forgejo/workflows/upstream-watch.yaml` with weekday schedule + `workflow_dispatch`
- [x] 3.2 Implement compare + single-issue create/update; never merge
- [x] 3.3 Verify workflow YAML is valid (parse) and the quiet path is documented in comments

## 4. Verify

- [x] 4.1 Run `/usr/local/bin/openspec validate upstream-watch` (or `openspec validate --change upstream-watch`) and confirm green
- [x] 4.2 Run `scripts/upstream-status.sh` and confirm it prints in-sync or the commit list without error
