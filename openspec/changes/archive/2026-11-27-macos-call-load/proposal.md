# Proposal

## Why

On Apple Silicon, a call with the local camera on still saturates a core and the bandwidth estimate collapses, while the capture conversion itself was measured as cheap. A server send limit that arrives before the camera or the share is sending is stored as already applied and never retried, so the outgoing picture can stay at the wrong size. The call report does not name which thread used the CPU, so the next change would be a guess.

## What Changes

- A send limit that cannot be applied because the camera or the share is not sending yet is applied when that source starts sending, including when the server does not send a new limit.
- On macOS, every two seconds of a call the call report records the CPU time each named thread used since the previous sample, which camera effects are on, and the process thermal state.
- No GPU capture rewrite in this change. The report decides that later.

## Capabilities

### New Capabilities

- `video-send-limits`: A media-controller resolution or bitrate limit is applied when the matching local source starts sending, even if the request arrived earlier.
- `macos-call-load`: A macOS call report shows per-thread CPU time, enabled camera effects, and thermal state on a two-second cadence.

### Modified Capabilities

## Impact

- Outgoing video limit handling and the call timeline on macOS.
- The macOS smoke checklist gains a camera-on minute that reads this report. Linux and Windows call reports do not gain the host-load lines.
