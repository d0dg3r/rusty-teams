# windows-camera Specification

## Purpose

Windows camera open in a call: the same physical camera stays selected across sessions, YUY2 frames reach the send path, and the camera does not dim the frame rate in indoor light.

## Requirements

### Requirement: The same Windows camera stays selected

The app SHALL remember a Windows camera by its stable device link when the platform provides one, and SHALL fall back to the list index only when that link is missing. Reopening the camera after a device-list refresh MUST select that same camera when it is still present.

#### Scenario: Camera list refreshes

- **WHEN** the user has selected a camera that has a stable device link and the camera list is built again
- **THEN** the selection still points at that camera
- **AND** it does not jump to whichever camera now occupies the old index

### Requirement: YUY2 frames are sent

A Windows camera that delivers YUY2 MUST have those frames converted to the call's planar video format and sent. The camera MUST NOT stay black or fail open only because the frame is YUY2.

#### Scenario: Camera offers YUY2

- **WHEN** the open camera delivers YUY2 frames
- **THEN** those frames are converted and enter the same send path as other camera formats

### Requirement: Indoor light does not drop the camera frame rate

While a Windows camera is open, the app SHALL request 50 Hz flicker reduction and SHALL ask the camera not to lower its frame rate for auto-exposure. Failure of that request MUST NOT stop the camera.

#### Scenario: Tuning is refused

- **WHEN** the camera rejects the flicker or exposure request
- **THEN** the camera stays open on the format that was already chosen
