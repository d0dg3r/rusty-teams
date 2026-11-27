# Proposal

## Why

On macOS, choosing Share a window did nothing. The app asked WebRTC for a window capturer, and that capturer has no system picker, so the share ended before the first frame. Upstream pull request 97 adds a ScreenCaptureKit window capturer. That pull request is still open. This fork needs the behaviour now.

## What Changes

- A window share on macOS opens the system window picker. Cancelling it leaves the call connected. Closing the shared window ends the share and shows a notice.
- The macOS package is Apple Silicon (arm64) and needs macOS 14. The published file is `macos-arm64.zip`.
- GitHub Actions stay a mirror stub. The window-share code does not turn GitHub into a build farm.

## Capabilities

### New Capabilities

- None.

### Modified Capabilities

- `screen-share`: a macOS window share uses the ScreenCaptureKit window picker, and a source that disappears ends the share with a notice.

## Impact

- macOS calls only. Linux and Windows share paths are unchanged.
- `vendor/webrtc-sys` gains the window capturer. The Forgejo macOS release job copies the arm64 zip.
