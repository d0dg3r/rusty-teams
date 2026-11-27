# Design

## Approach

Merge `upstream/main` into Forgejo `main`. The merge-base is `797e287e` and no path is changed on both sides, so the merge should be clean. Keep fork-only trees (Forgejo workflows, Flatpak, OpenSpec, Google calendar, `~/.local` install).

## Behaviour taken from Upstream

- Channel mention edits go through the chat service. Team and tag mentions stay on Graph (`797e287e`, already merged, unreleased).
- Store reads use their own connections so a writer lock does not stall the UI (`faad0468`, already merged, unreleased).
- An accepted 1:1 call falls back to the chat with the caller when the ring has no thread id (`7f664bf8`, already merged, unreleased).
- Aggregator threads of type `topic` or `space` are not chats (`ff2cccdd`). A missing conversation refreshes teams at most once a minute and drops chat rows that use a channel id.
- "See fewer channels" is rendered after the revealed channel rows (`577baf19`).
- VAAPI packed slice header bytes gain the H.264 start code in `vendor/webrtc-sys` (`47f0b8c1`, upstream #95).
- A refused token refresh logs Microsoft's reason (`0bb7cc15`, upstream #126). Log only.
- The upstream PR-gate label fix (`a0f84959`) is CI. It does not change the app.

## Release

Cargo version stays `0.6.1`. Tag `v0.6.1-joe.3` on Forgejo. `CHANGELOG.md` lists the user-visible fixes above. The tag push starts `.forgejo/workflows/release.yaml`.

## Risks

- `remove_chats` on a team refresh deletes rows whose ids are channel ids. Group chats use a different id shape and stay.
- Vendor VAAPI change is Linux hardware encode only. Windows and macOS encoders are untouched.
