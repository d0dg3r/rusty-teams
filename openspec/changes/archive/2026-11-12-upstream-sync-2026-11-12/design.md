# Design

## Context

See proposal.md — Why. Fork and upstream have diverged since `dc7f29f` (~59 upstream / ~35 fork). Sync is a merge on `sync/upstream-2026-11-12`, push only to Forgejo `origin`.

## Goals / Non-Goals

**Goals:**

- Upstream call window, chat motion, MCP meetings, and Manage team runnable on the fork
- Keep fork paths (locale, camera quality, Wayland share, agent providers, Forgejo CI, CBDT emoji)
- Workspace `0.3.0`, store `0030`/`0031`, CHANGELOG Joe entry

**Non-Goals:**

- No upstream PR with fork mix
- No rebase of 35 fork commits
- No full re-localization of every upstream string in one commit (EN fallback ok, follow-up allowed)

## Decisions

1. **Merge not rebase** — history already has merge commits; resolve conflicts once on sync branch.
2. **Upstream UI structure, fork media patches** — call/chat chrome from upstream; keep camera/SDP/Wayland/locale selectively.
3. **Emoji font ours** — binary `NotoColorEmoji.ttf` stays fork CBDT variant; upstream COLRv1 fix stays where code-side.
4. **Remove call_mini** — upstream drops mini for call window; fork follows.
5. **OpenSpec coarse capabilities** — four new + four modified specs instead of 59 single changes.

## Risks / Trade-offs

- [Risk] ~73 conflict files, build breaks after naive theirs → mitigation: merge media files manually, then `cargo test`
- [Risk] locale gaps on new chrome → mitigation: EN fallback; follow-up keys
- [Risk] camera vs new call-window API drift → mitigation: spec `camera-video-quality` + focused tests in calling/app-state

## Migration Plan

1. Merge on sync branch, conflicts, compile/test
2. Merge to `main`, push `origin`
3. Optional release tag `v0.3.0-joe.N` after smoke
4. Rollback: do not merge sync branch or revert merge on `main`
