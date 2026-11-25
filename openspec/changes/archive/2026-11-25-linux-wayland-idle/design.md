# Design

## Context

See proposal.md for why. Today `crates/app-base/src/user_activity.rs` samples every 15 seconds. `latest_input` already merges in-window input with `system_idle()`. On Windows that reads the system last-input time. On every other OS, including Linux, `system_idle()` returns `None`.

Upstream [danieldaeschle/rusty-teams#96](https://github.com/danieldaeschle/rusty-teams/pull/96) (Lukas Grundtner) adds Wayland `ext-idle-notify-v1` and an X11 screensaver fallback. This fork ships only the Wayland half. Product scope is Wayland sessions. The X11 screensaver path stays on that pull request for upstream users. This change does not open a competing upstream pull request.

`wayland-client` 0.31 and `wayland-protocols` 0.32 are already in `Cargo.lock` through other crates. `app-base` does not depend on them yet. `x11rb` stays as it is (`shape` only) for notification input shapes in `crates/app-base/src/notify/platform/x11_input.rs`.

## Goals / Non-Goals

**Goals:**

- Linux `system_idle()` returns a duration on Wayland when `ext-idle-notify-v1` binds.
- Prefer protocol version 2 (`get_input_idle_notification`) so inhibitors such as video playback do not count as activity. Fall back to version 1 when that is all the compositor offers.
- Credit pull request 96 in the module header, this change, and the changelog.

**Non-Goals:**

- X11 screensaver idle (`x11rb` feature `screensaver`).
- Changing `IDLE_AFTER` (five minutes) or the Teams presence publish path.
- A second upstream pull request.

## Decisions

1. **New module `crates/app-base/src/linux_idle.rs`, Linux-only.** A background thread connects with `wayland-client`, binds `wl_seat` and `ext_idle_notifier_v1` (versions 1 through 2), and subscribes with a 5-second quiet period. On `idled`, idle is measured from five seconds before the event, because the compositor only notifies after that quiet period. On `resumed`, idle is zero. `system_idle()` reads that state. If bind or connect fails, the state stays unavailable and the function returns `None`.

   Alternative considered: call the X11 screensaver extension when `WAYLAND_DISPLAY` is unset, as in pull request 96. Rejected here because this product line does not run X11 sessions. That is a scope cut, not a claim that the X11 path is wrong.

2. **`user_activity::system_idle` on Linux delegates to the module.** The `not(windows)` stub becomes `not(any(windows, target_os = "linux"))`. macOS stays `None`.

3. **Direct dependencies on `app-base` for Linux only:** `wayland-client` 0.31 and `wayland-protocols` 0.32 with features `client` and `staging`. No new `x11rb` features.

4. **Unit test covers the duration helper only** (`None` is zero, a recorded start yields the elapsed time). No display in CI.

## Risks / Trade-offs

- [Compositor has no `ext-idle-notify` (common on Mutter)] → bind fails, behaviour stays window-only. Same as today.
- [Idle time jumps in 5-second steps] → the presence threshold is five minutes, sampled every 15 seconds, so the step is inside the existing tolerance.
- [Watcher thread dies] → later samples keep the last known state or `None` if the protocol never became available. The thread loops on `blocking_dispatch` and stops only when the connection fails.

## Migration Plan

Fork-only code on `origin`. No data migration. Rollback is reverting the module and the Linux `system_idle` branch. Upstream pull request 96 is left open and unchanged.

## Open Questions

None.
