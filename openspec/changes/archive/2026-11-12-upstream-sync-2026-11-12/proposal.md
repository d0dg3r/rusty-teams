# Proposal

## Why

Upstream (`danieldaeschle/rusty-teams`) is ahead on many call, chat, and MCP features since the last merge base. The fork needs that state without losing locale, camera/Wayland, agent providers, Forgejo CI, and Linux fixes.

## What Changes

- Adopt call/meeting window, gallery paging, join preview, and call toolbar/layout like new Teams
- MCP: `write_message` / `add_reaction`, meeting organization, free time, review settings, and persistent meeting proposals
- Chat: message animations, typing indicator in chat, out-of-office notice, context menus, splash, native Manage team page
- Store migrations `0030` / `0031` and workspace version `0.3.0`
- Fork behaviour kept: UI locale DE/EN, camera quality, Wayland ScreenCast, Google Calendar, agent providers, Forgejo release/CI, bundled CBDT emoji font

## Capabilities

### New Capabilities

- `call-window-layout`: dedicated call/meeting window, toolbar order, gallery paging, and join preview
- `mcp-meetings-write`: MCP tools for write/reactions, free time, and meeting organization including persistent proposals
- `chat-presence-motion`: message appear, typing in chat, out-of-office notice, and startup splash
- `manage-team-page`: native team management page with member list

### Modified Capabilities

- `call-media-negotiation`: merge upstream relay/answer fixes and fullband Opus with fork camera/1:1 negotiation
- `screen-share`: keep upstream share-stop/Windows fixes with Wayland ScreenCast portal
- `camera-video-quality`: camera Auto/720p/1080p and 30-fps path remain after call UI sync
- `ui-locale`: new upstream UI strings covered via locale keys (English fallback)

## Impact

- Hot zones: `crates/app` call/chat views, `crates/app-call-model`, `crates/calling`, `crates/mcp`, `crates/store` migrations, `Cargo.toml`
- Releases stay Joe tags (`v0.3.0-joe.N`) on Forgejo; no upstream PR from this sync
