## Why

On Wayland, stopping an active portal share from the desktop indicator closes the portal session as a permanent capture error. Since the macOS share-stop change, every permanent error shows "the system stopped the capture", so a deliberate stop looks like a failure.

## What Changes

- After at least one frame of an active Wayland portal share, a permanent capture error ends local sharing quietly and keeps the call connected.
- A permanent error before the first frame still shows a notice.
- macOS, Windows, and plain X11 keep their current notices. A macOS menu-bar stop stays quiet through the existing user-stop signal.

## Capabilities

### New Capabilities

### Modified Capabilities

- `screen-share`: an active Wayland portal share that the desktop ends after frames have arrived stops quietly, while a permanent error before the first frame stays a notice.

## Impact

- Portal error classification in `crates/calling/src/screen.rs`. No vendor or PipeWire change. The in-app source list on Windows and X11 is unchanged.
