# Tasks

- [x] 1. Validate this change with `openspec validate sync-upstream-2026-11-26`
- [ ] 2. Merge `upstream/main` into Forgejo `main` and keep fork-only packaging, CI, and OpenSpec
- [ ] 3. Add `CHANGELOG.md` section `0.6.1-joe.3` for the unreleased sync and the five new upstream commits
- [ ] 4. `cargo test -p core --lib native::chat::tests` and `cargo test -p store --lib`
- [ ] 5. Annotated tag `v0.6.1-joe.3` on the changelog commit and push `main` plus the tag to `origin`
