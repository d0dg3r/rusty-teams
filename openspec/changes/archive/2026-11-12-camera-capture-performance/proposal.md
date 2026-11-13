# Proposal

## Why

After the 1:1 camera fix the app on Logitech C930e (USB 2.0) often opens YUYV 1920×1080 at 5 fps instead of MJPEG at 30 fps. That feels like heavy lag and frame drops although the encoder is not CPU-limited.

## What Changes

- Camera open chooses formats with at least 30 fps; on HD over USB 2.0 prefer MJPEG 1080p/720p.
- MJPEG frames are decoded locally (zune-jpeg → I420) without the slow raw-closest path.
- UVC controls: fixed frame rate and 50 Hz mains frequency (Switzerland) best effort.
- Call report/timeline shows chosen format, capture fps, and decode time.

## Capabilities

### New Capabilities

- (none)

### Modified Capabilities

- `camera-capture`: 30-fps format choice including MJPEG, decode path, UVC tuning, and telemetry.

## Impact

- `crates/calling/src/camera.rs` (open, decode, controls)
- Possibly call timeline/stats for format and capture fps
- C930e and similar UVC cameras without NV12 at HD
