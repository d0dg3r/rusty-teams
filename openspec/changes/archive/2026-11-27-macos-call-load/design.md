# Design

## Context

`apply_send_limit` in `crates/calling/src/video_send.rs` returns `Ok(None)` when the camera or the share is not sending, and it does not store `requested`. `RequestFilter::admit` in `crates/calling/src/send_control.rs` has already stored that limit, so a repeat is dropped. `refresh_send_limits` only looks at `requested`, and it already reapplies when the frame size becomes known.

The call stats loop in `crates/calling/src/call/mod.rs` already ticks every 200 ms and writes a health sample every two seconds (`HEALTH_EVERY_TICKS`). Camera effects are readable from `BlurSettings` (`enabled`, `standout`, `CameraEffects`).

## Goals / Non-Goals

**Goals:**

- Keep a send limit that could not be applied, and apply it when that source starts sending and again when the frame size becomes known.
- On macOS, append a timeline line every two seconds with per-thread CPU deltas, effect flags, and thermal state.

**Non-Goals:**

- Replacing nokhwa or the ScreenCaptureKit BGRA copy.
- Recording host load on Linux or Windows.
- Using `sample`, which suspends the process.

## Decisions

1. On the not-sending path, store `RequestedLimits` with `applied_for: None` and return `Ok(None)`. `refresh_send_limits` then applies the stored limit once a frame size exists, because `None` is not equal to that size. `start_camera` and `start_share` call the same refresh so the limit is not waiting for the next stats tick only. A newer `apply_send_limit` overwrites `requested`.
2. Host load lives in `crates/calling/src/host_load.rs`. The line formatter is pure and tested on every platform. Mach `task_threads` / `thread_info` and `NSProcessInfo.thermalState` are compiled only for `target_os = "macos"`. CPU time is the delta of user plus system time since the previous sample, kept on the call task, not in a process-global map. Unnamed threads use their Mach thread id. The thread list from `task_threads` is deallocated with `vm_deallocate`.
3. The stats loop records `host load` only under `cfg(target_os = "macos")`, on the same two-second cadence as the health sample. Effect text is `blur`, `standout`, and the existing `CameraEffects` flags. Thermal words are `nominal`, `fair`, `serious`, `critical`.
4. `calling` gains macOS-only dependencies `libc`, `objc2`, and `objc2-foundation` (`NSProcessInfo`). Linux keeps its existing `libc` dependency.

## Risks / Trade-offs

- The Mach probe cannot be executed in the Linux test run. The formatter and the send-limit path are tested here. The macOS probe is compiled on the `macos-arm64` release runner only when that tag is built; this change does not cut a tag.
- `task_threads` itself costs a little CPU every two seconds. That is the measurement, not a capture change.
- A limit applied before the first frame uses scale 1. The existing frame-size refresh replaces it once the size is known. The requirement is met by that second apply.

## Migration Plan

No stored data. Rollback is reverting the change.

## Open Questions

None. The Apple Silicon camera-on minute is an operator step in `docs/macos-smoke.md`. It is not a code task and it does not start a capture rewrite.
