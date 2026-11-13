# Proposal

## Why

The camera looks soft because capture and stage receive are pinned to ~720p although many cameras and the Teams mixer can do 1080p. Users should be able to control send/receive quality deliberately without 4K complexity.

## What Changes

- Camera capture prefers **1080p @ 30 fps** (widescreen), with fallback to 720p when the camera cannot deliver it.
- Stage receive limits rise to **1080p class** (similar order of magnitude as today’s screen-share `max-fs`/`max-mbps` sizes).
- New persistent **video quality** setting: `Auto` | `720p` | `1080p` (no 4K).
  - Drives capture ceiling, `maxVideoSendCapabilities`, and stage request limits together.
  - `Auto` = highest supported tier up to 1080p.
- Small-tile and screen-share limits stay unchanged.
- Codec remains H.264; no H.265.

## Capabilities

### New Capabilities

- `camera-video-quality`: Capture preference, send capabilities, and stage receive limits for camera video, including user choice Auto/720/1080.

### Modified Capabilities

- (none)

## Impact

- Capture/format choice and downscale in `crates/calling` (camera path).
- Stage `applyChannelParameters` / receive limits and send capabilities in `crates/calling`.
- UI: camera menu and call/device settings in `crates/app`; persistence like existing call settings.
- Tests: format choice, limit constants, setting persistence; verify with `cargo test -p calling --lib` and focused app tests.
