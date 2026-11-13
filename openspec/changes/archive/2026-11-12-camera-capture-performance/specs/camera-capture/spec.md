# Spec Delta

## Purpose

Local camera capture in calls and prejoin with stable HD frame rate (target 30 fps), including MJPEG devices without NV12.

## ADDED Requirements

### Requirement: Capture picks at least 30 fps when available

When the device offers at least one format at 30 fps, the app MUST open a stream at least 30 fps. An open below 30 fps (e.g. YUYV 1080p@5) MUST be discarded and replaced by the next candidate while a 30-fps candidate remains.

#### Scenario: C930e Auto picks MJPEG 1080p@30

- **WHEN** the camera offers YUYV only up to 1080p@5 / 720p@10 and MJPEG up to 1080p@30 and quality is Auto or 1080p
- **THEN** the app opens MJPEG 1920×1080 at 30 fps (or another 30-fps HD format), not YUYV@5

#### Scenario: 720p quality

- **WHEN** quality is 720p and MJPEG 1280×720@30 is available
- **THEN** the app opens that format (or raw 30 fps at the same height), not a format below 30 fps

### Requirement: MJPEG is decoded and sent

MJPEG frames MUST be decoded locally to I420 and fed into the existing send pipeline (effects → encoder) without aborting the user with an undecodable notice while decode succeeds.

#### Scenario: MJPEG frame becomes I420

- **WHEN** the capture stream delivers MJPEG
- **THEN** an I420 frame is produced for preview and send, and the timeline counts capture frames

### Requirement: UVC frame rate and mains frequency (best effort)

After a successful open the app SHOULD disable `exposure_dynamic_framerate` and set `power_line_frequency` to 50 Hz when those controls exist. Missing controls MUST NOT stop the stream.

#### Scenario: Controls missing

- **WHEN** the camera does not offer one of the controls
- **THEN** the stream continues without an error dialog

### Requirement: Capture telemetry in the call report

On camera start the timeline MUST name the chosen format (pixel format, resolution, fps). Running stats SHOULD show capture fps and decode time so a call report shows whether 30 fps is arriving.

#### Scenario: Format in the timeline

- **WHEN** the camera starts successfully
- **THEN** the timeline contains an entry with a format like `MJPG 1920x1080 @30`

## MODIFIED Requirements

### Requirement: Format property failure does not block open

If querying supported camera formats or the running format property fails, the app MUST still open the stream with a 30-fps-capable candidate (MJPEG or raw format) when the device allows it. Only when no 30-fps open succeeds MAY the app use a slower fallback; if everything fails the app MUST show the user the error.

#### Scenario: Property failed, 30-fps format available

- **WHEN** the user turns the camera on and the format property fails but the device offers MJPEG or raw at 30 fps
- **THEN** local camera starts with a 30-fps format and does not show a fatal format-property stop
