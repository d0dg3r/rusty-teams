# Proposal

## Why

Window and screen sharing today follows the Windows model: the app lists sources and shows thumbnails. Under Wayland an app may not enumerate foreign windows. On KDE, GNOME, and Hyprland the share button therefore stays empty, dead, or stuck on a placeholder although PipeWire and the ScreenCast portal are already available on the desktop.

## What Changes

- Under Wayland (set `WAYLAND_DISPLAY`, even when an XWayland `DISPLAY` also exists) the share menu offers two actions without thumbnails: share entire screen, share a window.
- Each action opens the running desktop’s ScreenCast dialog. KDE, GNOME, and Hyprland draw that dialog themselves; the app always makes the same request, filtered to monitors or windows respectively.
- After selection, frames flow through the existing share pipeline (banner, stop, stage).
- Cancelling the dialog leaves the call running without an error notice.
- When no ScreenCast portal is available, a clear notice appears instead of a silently dead button.
- When sharing the entire screen, the app’s own window steps aside so it does not remain in the capture.
- Windows and a plain X11 session keep the existing list with thumbnails.

## Capabilities

### New Capabilities

- `screen-share`: Choose a source for local screen or window sharing in a call, including Wayland portal and the existing list on Windows and plain X11.

### Modified Capabilities

- None. `linux-call-audio` (computer sound) stays unchanged.

## Impact

- Share menu and starting local capture in a connected call.
- Runtime under Wayland: desktop ScreenCast portal (KDE, GNOME, Hyprland), PipeWire, a GLib main loop before the portal call. The bundled libwebrtc build already includes PipeWire.
- No compositor-specific path (`hyprctl` and similar private lists).
- Receiving a remote share, H.264 stage, computer sound, restore token, and thumbnails in our own menu under Wayland stay outside this change.
- Delivery on the fork. No Upstream PR of the whole fork line.
