## ADDED Requirements

### Requirement: A share records empty frames and why sending stopped

While a desktop capture is delivering frames, the app MUST record the frame size and whether the buffer is blank. A blank buffer is one whose sampled bytes are almost all zero. The app MUST record this for the first frame and again whenever a later frame changes between blank and not blank. When that capture ends and the app stops sending the share, it MUST record the reason, using a quiet marker when the portal ended the share without a notice.

#### Scenario: First frame is blank

- **WHEN** the first captured frame of a share is blank
- **THEN** the call log records that frame’s size and that it is blank

#### Scenario: A later frame has content

- **WHEN** a share has recorded a blank frame and a later frame is not blank
- **THEN** the call log records the new frame’s size and that it is not blank

#### Scenario: The portal ends the share quietly

- **WHEN** the desktop capture ends without a notice and the app stops sending the share
- **THEN** the call timeline records that the share stopped quietly
