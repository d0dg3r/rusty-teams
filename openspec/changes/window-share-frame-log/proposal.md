## Why

A window share in a call can reach the other side as a frozen black picture. The last call encoded real-sized frames for several seconds, then the app set the share back to receive-only. The dump cannot show whether those frames were empty, or which portal event stopped sending.

## What Changes

- While a desktop capture is sending, record when a frame is almost entirely zero bytes, and when a later frame is not.
- When that capture ends and the share sender is switched off, record the reason (a quiet portal stop, or the notice text).

## Capabilities

### New Capabilities

- None.

### Modified Capabilities

- `screen-share`: a window or screen share records empty frames and the reason sending stopped.

## Impact

- Call timeline and the client log gain two share lines. No change to capture, encoding, or when a share stops.
