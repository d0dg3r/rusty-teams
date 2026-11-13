# Design

## Context

See `proposal.md` — Why. Today: `CAPTURE_HEIGHT = 720`, preference fixed at 720, downscale ceiling 1080 but `fit_widescreen` trims back to 720; stage receive `max-fs=3600` (~720p); screen already `8160` (~1080p). Codec filter stays H.264 (`h264_only`).

## Goals / Non-Goals

**Goals:**

- One quality tier drives capture ceiling, send advertise, and stage receive together.
- 1080p as practical maximum; Auto falls back cleanly to 720p.
- Existing small-tile and screen-share limits untouched.

**Non-Goals:**

- 4K UI or 4K advertise.
- H.265 / AV1.
- Forcing mixer bitrate beyond Teams `controlVideoStreaming` responses.
- Change to the screen-share capture path.

## Decisions

### 1. One setting for capture + advertise + stage

**Choice:** `VideoQuality { Auto, P720, P1080 }` affects all three.

**Why:** Separate send/receive sliders duplicate UI and rarely explain perceived softness. Stage and self-view should share the same expectation.

**Alternative:** Change capture only — rejected because stage would still request 720p.

### 2. Tie constants to macroblock budgets

**Choice:** 720p stage keeps `max-fs=3600` / today’s `max-mbps`/`max-fps`; 1080p stage takes today’s screen `ReceiveLimits` (`8160` / `135_000` / `1500` fps units) or a documented 1080p camera variant with the same `max-fs` if screen FPS is too low for camera — then keep `max-fps` for 1080p stage at camera level (~3000) and raise `max-mbps` proportionally.

**Apply recommendation:** `max-fs=8160`, `max-fps=3000`, scale `max-mbps` so 1080p@30 fits macroblock·FPS (≈ `8160 * 30` = 244800), do not blindly copy screen 1500 FPS.

### 3. Parameterize capture API

**Choice:** Derive preference height and downscale ceiling from active quality instead of hard `CAPTURE_HEIGHT`. `pick_format` / `fit_widescreen` / fallback `Resolution` read the same ceiling. `LARGEST_DOWNSCALED_HEIGHT` for 1080 ceiling may allow higher sensor formats up to e.g. 1440 as long as the result scales to ≤1080 — no 4K mode in the UI.

### 4. Persistence and UI placement

**Choice:** Persist beside existing device/call settings; choice in camera menu (call + prejoin), labels «Auto», «720p», «1080p». Default `Auto`. Change in call: reopen camera track if needed; stage subscriptions repost limits (`applyChannelParameters`).

### 5. Codec unchanged

H.264-only remains. Quality ≠ codec change.

## Risks / Trade-offs

- [Blur/effects more expensive at 1080p] → Mitigation: Auto still 1080; optional «Performance» later if measured drops — not in this change.
- [Mixer ignores higher advertise] → Mitigation: local self-view and capture still sharper; raise stage request regardless.
- [Camera without 30fps-1080] → Mitigation: fallback 720; do not hard-fail start.
- [Screen limits wrong for stage (low max-fps)] → Mitigation: decision 2 with camera-suitable `max-fps`/`max-mbps`.

## Migration Plan

- Default Auto → users without a setting get 1080 where possible (behaviour changes noticeably).
- Rollback: setting to 720p or code revert of capture constants.

## Open Questions

- Whether prejoin preview uses the same quality tier immediately or only after join (prefer: immediately, consistent with call).
