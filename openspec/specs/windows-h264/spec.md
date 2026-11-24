# windows-h264 Specification

## Purpose

Outbound camera video on Windows prefers a hardware H.264 encoder and keeps the call on a software encoder when the hardware path cannot run.

## Requirements

### Requirement: Camera video prefers hardware H.264

On Windows, outbound camera video SHALL use a hardware H.264 encoder when the platform can create one. The encoder SHALL target low latency and a steady bitrate.

#### Scenario: Hardware encoder is available

- **WHEN** the user sends camera video on Windows and a hardware H.264 encoder can be created
- **THEN** the outbound camera stream is encoded with that hardware encoder

### Requirement: Software encoder takes over when hardware cannot start

If the hardware encoder cannot be created or fails to start, the call SHALL fall back to the software video encoder and SHALL keep sending camera video.

#### Scenario: Hardware encoder fails to start

- **WHEN** camera video starts and the hardware encoder cannot be created
- **THEN** the outbound camera stream uses the software encoder
- **AND** the camera does not stay off only because the hardware encoder failed
