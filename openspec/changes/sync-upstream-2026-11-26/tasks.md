# Tasks

- [x] 1. Validate this change with `openspec validate sync-upstream-2026-11-26`
- [x] 2. Merge `upstream/main` into Forgejo `main` and keep fork-only packaging, CI, and OpenSpec
- [x] 3. Add `CHANGELOG.md` section `0.6.1-joe.3` for the unreleased sync and the five new upstream commits
- [x] 4. `cargo test -p teams-core --lib a_channel_thread_from_the_aggregator_is_no_chat`, `cargo test -p teams-core --test engine the_teams`, and `cargo test -p store --lib`
- [x] 5. Annotated tag `v0.6.1-joe.3` on the changelog commit and push `main` plus the tag to `origin`
