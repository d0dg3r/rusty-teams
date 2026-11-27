# video-send-limits Specification

## Purpose

Apply a media-controller send limit to the local camera or screen share when that source starts sending, including a limit that arrived while nothing was being sent.

## Requirements

### Requirement: A send limit that arrived early is applied when sending starts

When the media controller sends a resolution, frame-rate, or bitrate limit for the local camera or the local share, and that source is not sending yet, the client MUST keep the limit and MUST apply it when that source starts sending. The client MUST do this even if the controller does not send the same limit again. A later limit for the same source MUST replace the kept one. A limit that was already applied to the current frame size MUST NOT be applied again unless the frame size changes or the controller asks for a keyframe.

#### Scenario: Camera limit arrives while the camera is off

- **WHEN** the controller sends a lower camera resolution while the local camera is not sending
- **AND** the local camera later starts sending
- **AND** the controller does not send a new limit
- **THEN** the outgoing camera uses that earlier limit

#### Scenario: Share limit arrives before the share starts

- **WHEN** the controller sends a share limit while nothing is being shared
- **AND** the user then starts a share
- **THEN** the outgoing share uses that limit

#### Scenario: A newer limit replaces the kept one

- **WHEN** a limit is kept because the camera is not sending
- **AND** the controller sends a different limit for the camera before it starts
- **THEN** the camera starts with the newer limit
