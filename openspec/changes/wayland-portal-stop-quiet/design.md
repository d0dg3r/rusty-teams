## Context

See proposal.md for why a Wayland desktop stop is reported as a permanent capture error. `active_portal_error` in `crates/calling/src/screen.rs` maps every `Permanent` error to a notice. `StoppedByUser` exists only for the macOS ScreenCaptureKit capturer. On Wayland the frame callback ignores results until a source is selected; cancel before that arrives as `OnCancelled`.

## Goals / Non-Goals

**Goals:**

- End an active delegated portal share quietly when `Permanent` arrives after at least one frame.
- Keep a notice when `Permanent` arrives before any frame, and when it arrives on a non-delegated capturer after frames.

**Non-Goals:**

- Changing the Windows and plain X11 source-list capturer.
- Changing macOS `StoppedByUser`, `SourceGone`, or the pre-selection picker mapping.
- Patching the WebRTC or PipeWire capturer.

## Decisions

1. Track whether the portal callback has seen an `Ok` frame. Quiet `Permanent` only when the capturer has a delegated picker and that flag is set. Otherwise `Permanent` stays the notice "the system stopped the capture".
2. Set the flag on any `Ok` frame, including a frame that is not delivered because its buffer is too short. "Frames arrived" is the signal the desktop session was running.
3. Leave `SourceGone` and `Temporary` as they are. Wayland does not emit `SourceGone`, so a closed window after frames uses the same quiet path as the desktop stop.

Alternative considered: map every Wayland `Permanent` to quiet, including before the first frame. Rejected, because a portal or PipeWire failure that never produces a frame would then look like a successful cancel after the share banner is already up.

## Risks / Trade-offs

- [Wayland cannot tell a desktop stop from a closed window or a dead stream after the first frame] → Both end quietly and the call stays connected. A real mid-share failure no longer shows a notice. That is the limit of the portal signal.
- [A stop in the gap after the picker confirms and before the first frame still shows a notice] → Accepted. That gap is the failure case, not the indicator click after sharing has started.
