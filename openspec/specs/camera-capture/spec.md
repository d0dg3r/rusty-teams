# camera-capture Specification

## Purpose

Local camera start in calls and prejoin when the device offers formats but property queries fail.

## Requirements

### Requirement: Format property failure does not block open

If querying supported camera formats or the running format property fails, the app MUST still open the stream with a 30-fps-capable candidate (MJPEG or raw format) when the device allows it. Only when no 30-fps open succeeds MAY the app use a slower fallback; if everything fails the app MUST show the user the error.

#### Scenario: Property failed, 30-fps format available

- **WHEN** the user turns the camera on and the format property fails but the device offers MJPEG or raw at 30 fps
- **THEN** local camera starts with a 30-fps format and does not show a fatal format-property stop

#### Scenario: No fallback possible

- **WHEN** neither format list nor fallback open yields a usable format
- **THEN** the camera stays off and the app shows the error clearly

### Requirement: Capture picks at least 30 fps when available

When the device offers at least one format at 30 fps, the app MUST open a stream at least 30 fps. An open below 30 fps (e.g. YUYV 1080p@5) MUST be discarded and replaced by the next candidate while a 30-fps candidate remains.

#### Scenario: C930e Auto picks MJPEG 1080p@30

- **WHEN** the camera offers YUYV only up to 1080p@5 / 720p@10 and MJPEG 1080p@30 is the highest 30-fps format within the selected 1080p ceiling (or the only 30-fps HD mode available for Auto downscaling)
- **THEN** the app opens a 30-fps MJPEG HD format rather than YUYV@5

#### Scenario: 720p quality

- **WHEN** quality is Auto or 720p and MJPEG 1280×720@30 is available
- **THEN** the app opens that 720p@30 format (or raw 30 fps at the same height), not a format below 30 fps

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

### Requirement: Linux lists capture nodes only

On Linux the camera list MUST drop a node only when that node is known not to capture video. A node whose capture capability is unknown MUST stay listed. A metadata node that shares the capture node's name MUST NOT appear. One physical camera MUST appear once. The default camera MUST be a capture node when one is known. Windows and macOS lists MUST stay unchanged.

#### Scenario: C930e metadata node is hidden

- **WHEN** the camera offers a capture node and a metadata node under the same name
- **THEN** the list shows that name once and selecting it opens the capture node

#### Scenario: Default is the capture node

- **WHEN** the user starts the camera with the default choice and a metadata twin exists
- **THEN** the app opens the capture node, not the metadata node

#### Scenario: Unknown capability stays listed

- **WHEN** the capability query cannot open the node
- **THEN** the node stays in the camera list

#### Scenario: Capture node still fails

- **WHEN** the capture node itself cannot be opened
- **THEN** the camera stays off and the app shows the error
