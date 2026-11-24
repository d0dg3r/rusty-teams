# camera-video-quality Specification

## Purpose

Controls the resolution at which the local camera is captured and offered to the call, and the quality requested for stage camera receive — selectable as Auto, 720p, or 1080p.

## Requirements

### Requirement: Camera capture prefers the selected quality ceiling

The client SHALL capture the local camera at the highest supported widescreen format at least 30 fps that does not exceed the active quality ceiling (720p or 1080p). Auto SHALL use a 720p capture ceiling; explicit 1080p SHALL use a 1080p ceiling when the camera can deliver it, otherwise 720p. The client SHALL NOT offer or use a 4K camera quality mode.

#### Scenario: Camera supports 1080p with Auto

- **WHEN** video quality is Auto and the selected camera exposes both 1280×720 and 1920×1080 widescreen formats at ≥30 fps
- **THEN** capture uses the 720p-class format unless the user explicitly selects 1080p

#### Scenario: Camera supports 1080p when 1080p is selected

- **WHEN** video quality is set to 1080p and the selected camera exposes a suitable 1920×1080 (or equivalent 16:9) format at ≥30 fps
- **THEN** capture uses that 1080p-class format

#### Scenario: Camera only supports 720p

- **WHEN** video quality is Auto or 1080p and the camera cannot provide a suitable 1080p format
- **THEN** capture falls back to a suitable 720p format without failing camera start solely for that reason

#### Scenario: User locks 720p

- **WHEN** video quality is set to 720p and a higher camera format is available
- **THEN** capture stays at or below 720p

### Requirement: Send capabilities match capture ceiling

After the local camera size for sending is known, the client SHALL advertise max video send capabilities whose width and height reflect that capture size (up to the active quality ceiling), so the meeting media path can request layers up to that size.

#### Scenario: 1080p capture is advertised

- **WHEN** the outbound camera frame size is 1920×1080
- **THEN** the send-capabilities update reports max width and height of at least 1920 on the largest side consistent with that frame

### Requirement: Stage receive requests use 1080p-class limits when allowed

For non-screen camera tiles shown as stage detail, the client SHALL request receive limits at 1080p-class macroblock and throughput budgets when the active quality ceiling is Auto or 1080p. When the ceiling is 720p, stage requests SHALL remain at 720p-class budgets. Small gallery tiles and screen-share receive limits SHALL keep their existing budgets.

#### Scenario: Stage at Auto or 1080p

- **WHEN** the user is subscribed to a participant camera on the stage and video quality is Auto or 1080p
- **THEN** the stage receive request uses 1080p-class `max-fs` / `max-mbps` budgets (same order of magnitude as today’s screen-share camera request, not the previous 720p stage budget)

#### Scenario: Stage locked to 720p

- **WHEN** video quality is 720p and the user is subscribed to a stage camera tile
- **THEN** the stage receive request uses 720p-class budgets

### Requirement: Video quality setting is user-visible and persistent

The product SHALL expose a video quality choice of Auto, 720p, and 1080p in the call/device camera controls, persist the choice across app restarts, and apply it to new captures and new stage subscriptions. Changing the setting while a call is active SHALL take effect for subsequent capture restarts and subsequent stage request updates without requiring an app relaunch.

#### Scenario: Persist across restart

- **WHEN** the user selects 1080p and later restarts the app
- **THEN** video quality remains 1080p

#### Scenario: Default is Auto

- **WHEN** no prior video quality choice exists
- **THEN** the effective choice is Auto

### Requirement: Quality settings survive call-window sync
After merging upstream call-window layout, the camera video quality setting (Auto / 720p / 1080p) SHALL still control capture ceiling and stage receive budgets as in the baseline camera-video-quality spec.

#### Scenario: Quality still applies in call window
- **WHEN** the user sets camera quality to 720p and joins a call in the dedicated call window
- **THEN** capture stays at or below 720p and stage receive budgets follow the 720p ceiling

### Requirement: Camera uplink adapts to sustained path stress

While sending camera video, the client SHALL prefer maintaining frame rate over resolution under encoder pressure and SHALL cap outbound camera bitrate below the mixer ceiling when round-trip time or packet loss stays elevated, recovering gradually once the path is clean.

#### Scenario: High RTT or packet loss caps camera bitrate

- **WHEN** consecutive call health samples report elevated round-trip time or packet loss while camera video is sending
- **THEN** the outbound camera bitrate cap steps down (never below a minimum floor) and recovers after sustained clean samples

### Requirement: Answered H.264 level covers the peer frame limits

When an H.264 answer carries both `max-fs` and `max-mbps`, the client SHALL raise `profile-level-id` to the lowest H.264 Table A-1 level that covers both limits. The client MUST NOT lower a level. An answer without both limits SHALL keep its level. A level-3.0 answer with 720p limits SHALL become level 3.1. A 1080p answer that already required level 4.0 SHALL stay at level 4.0.

#### Scenario: Level 3.0 with 720p limits

- **WHEN** the answer contains `profile-level-id` ending in level 3.0 and `max-fs=3600` with `max-mbps=108000`
- **THEN** the sent level is 3.1
- **AND** the `max-fs` and `max-mbps` values are unchanged

#### Scenario: Missing limits stay put

- **WHEN** the answer has a profile level and no `max-fs` or no `max-mbps`
- **THEN** the profile level is unchanged
