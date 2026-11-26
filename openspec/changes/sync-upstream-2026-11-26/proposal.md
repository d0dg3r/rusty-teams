# Proposal

## Why

Forgejo `main` is behind Upstream `main` by five commits, and the previous sync (channel-mention edits, store reads, the 1:1 chat button) has not shipped in a Joe release since `v0.6.1-joe.2`. Users still hit a frozen window, a failed channel edit, a missing chat button, a new channel listed as a group chat, and broken VAAPI slice headers.

## What Changes

- Merge `upstream/main` into Forgejo `main` and publish `v0.6.1-joe.3`.
- A channel post edit that adds a channel mention succeeds.
- Reads of the local store stay available while a long write runs, so the window does not freeze.
- An accepted one-to-one call shows the chat button.
- A new channel appears under its team. "See fewer channels" is the last row of that team.
- Linux VAAPI H.264 packed slice headers include their start code.
- When Microsoft refuses a token refresh, the log states the reason. No new user-facing control.

## Capabilities

### New Capabilities

- `channel-post-edit`: editing a channel post, including adding a channel mention
- `team-sidebar`: where a channel sits in the sidebar, and the "See fewer channels" row
- `linux-hardware-encode`: VAAPI H.264 bitstream shape for packed slice headers
- `responsive-store-reads`: the window keeps reading local data during a long write

### Modified Capabilities

- `call-window-layout`: an accepted one-to-one call offers the chat for that caller

## Impact

- Merge of `upstream/main` (`0bb7cc15` and parents): `crates/core` sidebar and chat classification, `crates/app` sidebar order, `crates/store` read connections (already on the fork, unreleased), `crates/session` refresh logging, `vendor/webrtc-sys` VAAPI wrapper.
- Fork-only delivery stays: Forgejo release jobs, Flatpak, OpenSpec, Google calendar, Linux install under `~/.local`.
- Release notes in `CHANGELOG.md` and tag `v0.6.1-joe.3` on `origin` only.

## Out of scope

- Upstream pull requests.
- Changing the Cargo package version off `0.6.1` (Joe tag namespace only).
- Archiving this change into `openspec/specs/` before the release tag. Archive follows the merge on the fork, after the tag is pushed.
