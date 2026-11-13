# Tasks

## 1. Merge and conflicts

- [x] 1.1 Branch `sync/upstream-2026-11-12` from `main` and `git merge upstream/main` (Verify: merge started, conflicts listed)
- [x] 1.2 Resolve call/chat UI conflicts in favour of upstream; remove `call_mini`; emoji font ours (Verify: no conflict markers in those files, `git add`)
- [x] 1.3 Merge calling/camera/Wayland/SDP conflicts and keep fork paths (Verify: no markers; camera/Wayland symbols still present)
- [x] 1.4 Resolve Shell, Conversation, Main, Calendar, MCP, agent API conflicts (Verify: no conflict markers under `crates`)

## 2. Version and docs

- [x] 2.1 Workspace version `0.3.0` and store migrations `0030`/`0031` (Verify: `Cargo.toml` + `migrations.rs`)
- [x] 2.2 CHANGELOG Joe entry for upstream sync (Verify: section under `0.3.0-joe.6` or next tag)

## 3. Verify and integration

- [x] 3.1 `cargo test` for store, mcp, calling and other green suites (Verify: tests pass)
- [x] 3.2 Merge sync branch to `main` and push to `origin` (Verify: `origin/main` contains upstream merge)

## Workflow follow-up

- Archive OpenSpec change after stable main (`/opsx-archive`)
- Follow up locale keys for new upstream chrome
- Smoke: locale, 1:1 call, Wayland share
