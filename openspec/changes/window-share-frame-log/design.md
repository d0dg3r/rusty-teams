## Context

The portal path converts each desktop buffer to a picture and feeds the share sender. A buffer of the right size is sent even when every byte is zero, which encodes as black. The sender goes inactive only when the capture thread ends and the app posts the share as receive-only.

## Goals / Non-Goals

**Goals:**

- Log the first captured frame’s size and how empty it is, and again when that emptiness flips.
- Log the stop reason on the call timeline when the share sender is switched off.

**Non-Goals:**

- Changing the portal capture, the colour conversion, or the stop path. Those stay until a later run shows empty frames or a stop that should have kept sending.

## Decisions

1. Sample every 64th byte. A full scan of a large window buffer on the capture thread is unnecessary for a blank check. A frame is blank when at least 95 percent of the sample is zero.
2. Log on the client log for the frame, and on the call timeline for the stop, so the next dump shows the reason next to the sender going inactive.
3. A quiet end (the portal closed after frames, with no notice) is recorded as `quiet`.

## Risks / Trade-offs

- A real picture that is mostly black can be logged as blank. The flip back to not-blank still shows that later frames had content.
- The log does not store pixels, so it cannot reconstruct the picture.
