# Proposal

## Why

In a 1:1 call under Hyprland, camera and screen share did not start. The escalation answer contained an extra m-line (`mid 3-0`) and Teams rejected with `InvalidNumberOfMedia`. A delayed same-peer answer for the camera was discarded after the 40s timeout. In parallel the local camera open failed with `CameraFormat: Failed to Fufill`.

## What Changes

- Escalation/Teams answers fold folded `x-multi-stream` back to one m-line (no extra `3-0` line).
- A same-peer answer that belongs to the last sent offer and arrives shortly after timeout is still applied.
- Camera open falls back to raw formats when the format property fails.
- **Out of scope:** command queue, portal lifetime, and PipeWire BGRA — only after retest if still needed.

## Capabilities

### New Capabilities

- `call-media-negotiation`: SDP/renegotiation behaviour for escalation answers and same-peer camera answers.
- `camera-capture`: local camera start despite failed format property.

### Modified Capabilities

- (none) — `screen-share` (portal dialog) stays unchanged.

## Impact

- Signaling/SDP in `crates/calling` (`sdp.rs`, `call.rs`)
- Camera open in `crates/calling/src/camera.rs`
- Call reports and retarget errors on 1:1 with multi-stream offers
