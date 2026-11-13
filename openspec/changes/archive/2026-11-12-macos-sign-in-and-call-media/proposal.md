# Proposal

## Why

On macOS the app does not start Chrome itself: without a manually opened debug port there is no sign-in. Screen sharing falls back to the source list while ScreenCaptureKit already offers the system dialog and leaves the list empty. Audio and camera already run over the same non-Windows path as Linux; behaviour should be specified and share plus login brought to the same level.

## What Changes

- Without `--endpoint` the app on macOS starts Chrome or Chromium with remote debugging and its own profile, keeps it headless when signed in, and shows the window only for login — then back to the background.
- With `--endpoint` the app attaches to an existing Chrome instance and does not start a second managed instance.
- Headless user agent is a macOS Chrome string, not a Windows NT string.
- Auto and Low send the CoreAudio ADM microphone track; Music Mode, Off, and computer sound use the software chain. Hangup ends the chain without killing the client.
- Camera preview and send use the system camera; usage strings in the `.app` remain required for system dialogs.
- Screen sharing on macOS opens the ScreenCaptureKit dialog for screen or window without an in-app preview list. Cancel stays silent; missing permission is a clear notice; the call stays connected.
- Windows and plain X11 keep the existing source list.

## Capabilities

### New Capabilities

- `macos-sign-in`: On macOS the app starts and manages Chrome/Chromium with remote debugging (dedicated profile folder), signs in to the Microsoft account through it, and keeps exactly one running app instance.
- `macos-call-audio`: On macOS remote and local user hear the same audio chain as on Linux (ADM for Auto/Low, software for music/off/computer sound), including camera preview and send over the system camera.

### Modified Capabilities

- `screen-share`: On macOS share opens the ScreenCaptureKit system dialog instead of an empty source list; Windows and plain X11 stay unchanged.

## Impact

- Browser start and login window on macOS (profile under Application Support, Chrome search under `/Applications`, `~/Applications`, and PATH).
- Share picker and starting local capture in a connected call on macOS.
- README status line for macOS: from «connects to a Chrome» to self-started Chrome like Linux.
- Delivery on the fork. No Upstream PR, no Windows WebView2, no built-in login without Chrome, no remaining roadmap gaps.
