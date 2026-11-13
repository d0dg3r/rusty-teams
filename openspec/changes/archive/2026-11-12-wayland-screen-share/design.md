# Design

## Context

See `proposal.md` for motivation. Today `crates/calling/src/screen.rs` enumerates screens and windows via `GetSourceList` and builds the menu in `crates/app/src/views/call_view.rs`. `can_share()` in `crates/app-call-model/src/model.rs` is true only when that list is non-empty. Thumbnails call `capture_frame` before the user picks anything.

Bundled libwebrtc is built with `WEBRTC_USE_PIPEWIRE`. `vendor/webrtc-sys/src/desktop_capturer.cpp` sets `allow_pipewire`. `BaseCapturerPipeWire` implements `GetDelegatedSourceListController`, `EnsureVisible`, and `Observe`. The cxx binding in `vendor/webrtc-sys` does not pass this controller through. The GLib loop in `vendor/libwebrtc/src/native/desktop_capturer.rs` starts only in `start()`, and only when `WAYLAND_DISPLAY` is set.

Under Wayland `GetSourceList` is a delegated list: at most one placeholder, usable only after selection in the desktop dialog.

## Goals / Non-Goals

**Goals:**

- One portal path for KDE, GNOME, and Hyprland, triggered by two menu actions.
- Windows and plain X11 keep list and thumbnails.
- Cancel, missing portal, and moving the main window on entire-screen share hook into the existing call flow.

**Non-Goals:**

- Restore token, thumbnails under Wayland, region pick, computer sound (`linux-call-audio`, `parec`).
- Compositor-private lists.
- Upstream PR. Binding change stays on the fork.

## Decisions

### Session via `WAYLAND_DISPLAY`

Portal path exactly when `WAYLAND_DISPLAY` is set, even beside `DISPLAY` for XWayland. Libwebrtc uses the same condition for the PipeWire capturer. `XDG_SESSION_TYPE` alone would diverge from the capturer.

The call task reports the mode once as an update (portal or list). The model stores it. `can_share()` in portal mode is true once the call is connected, even with an empty `share_sources`.

### Two actions, two capturer kinds

«Entire screen» creates a screen capturer, «A window» a window capturer. WebRTC maps that to portal types monitor and window. `CreateGenericCapturer` would mix both kinds in one dialog and undo the two actions.

`StartShare(ShareSource)` stays for list selection. Portal path gets its own command with kind (screen or window), no prior source id. No placeholder entry in `share_sources`, or thumbnails in `crates/calling/src/call.rs` fire the dialog when opening the menu.

### Dialog via delegated controller

Flow after click:

```
GLib default context running
        |
        v
Capturer Start(callback)     without SelectSource
        |
        v
Observe + EnsureVisible
        |
        +-- selection --> GetSourceList, SelectSource, existing frame loop
        +-- cancel     --> drop capturer, no Notice
        +-- error      --> CallUpdate::Notice, no share
```

`EnsureVisible` is required: `BaseCapturerPipeWire` attaches the portal dialog there. Binding in `vendor/webrtc-sys/include/livekit/desktop_capturer.h` and `vendor/libwebrtc` gets Observe, EnsureVisible, and the three callbacks. Keep thin so a libwebrtc bump stays manageable.

One GLib loop per process on the default context, started before `Start` or `EnsureVisible`, alive while portal share is possible. Starting and stopping a loop per capturer tears down the portal session. Controller callbacks run on the loop thread and hop to the existing capture owner before the frame loop blocks. The loop itself is not joined.

### Main window on entire screen

`SetExcludedWindow` and `sync_capture_exclusion` in `crates/app/src/call/overlay.rs` do not apply on PipeWire: the compositor delivers the finished image. `minimize_for_share` minimizes only when `minimize_on_share_start` in `crates/app-state/src/call/share_overlay.rs` sees overlap. Wayland does not expose global rects.

Portal entire-screen always minimizes, regardless of rects. Window share does not minimize; the chosen window is the capture.

### Notice when portal is missing

If capturer creation or `EnsureVisible` fails, text goes through `CallUpdate::Notice`. Existing tooltip «Sharing starts once the call is connected» stays for unconnected calls.

## Risks / Trade-offs

- [Portal ignores type filter and shows monitors and windows together] → Request stays screen- or window-capturer. Verify on this Hyprland. Do not build a second in-app list.
- [Frames stay black, DMA-BUF does not arrive as CPU image] → Manual check on Hyprland. Existing I420 conversion in `screen.rs` expects filled frame bytes. Empty frames must not count as successful share.
- [Portal call from wrong thread] → Loop first, default context, `Start` and `EnsureVisible` only after.
- [Multiple portal implementations installed] → App does not pick implementation. Desktop routes ScreenCast (here `hyprland-portals.conf` with `default=hyprland;gtk`).
- [Binding breaks on next libwebrtc bump] → Add controller callbacks only, no copy of portal logic.

## Migration Plan

No persisted state. Rollback is the commit. Runtime expects PipeWire and a desktop ScreenCast portal. `README.md` mentions the portal for Linux share in one sentence. Delivery on `fork` only.
