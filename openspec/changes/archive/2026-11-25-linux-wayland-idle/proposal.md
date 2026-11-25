# Proposal

## Why

On Linux the app treats the user as idle unless the pointer or keyboard moves inside its own window. After five minutes in another application Teams shows Away, and a freshly started session stays inactive until the first click in the window. Windows already uses system-wide last input. Upstream pull request 96 (Lukas Grundtner) diagnoses the same gap and implements both Wayland and X11. This product line runs Wayland sessions only, so the fork ships the Wayland slice and leaves the X11 screensaver path with that pull request.

## What Changes

- On a Wayland session, input outside the app window counts as user activity for presence, using the compositor idle notification (input-only where the compositor offers that version, so a playing video does not count as activity).
- Without a Wayland display, or when the compositor does not offer the protocol, presence stays based on input inside the app window, as today.
- The five-minute idle threshold and the report to Teams stay the same.
- No X11 screensaver idle path. No second upstream pull request that removes the X11 half of pull request 96.

## Capabilities

### New Capabilities

- `linux-system-idle`: System-wide idle time on Linux Wayland feeds presence, so work in other applications keeps the user Available until five minutes without input.

### Modified Capabilities

- None.

## Impact

- Linux presence sampling in the app base activity tracker.
- New direct Linux dependencies on the existing Wayland client libraries already in the lockfile.
- Out of scope: X11 sessions, changing the five-minute threshold, changing how presence is published to Teams, and any upstream pull request that competes with pull request 96.
