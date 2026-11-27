## ADDED Requirements

### Requirement: Desktop stop of an active Wayland share is quiet

When a Wayland portal share has already delivered at least one frame, a permanent capture error MUST end local sharing without an error notice, and the call MUST stay connected. A permanent capture error before the first frame MUST still show a notice.

#### Scenario: Indicator stop after frames

- **WHEN** the user stops sharing from the desktop indicator after frames have been delivered under Wayland
- **THEN** local sharing ends
- **AND** the call stays connected
- **AND** no error notice appears

#### Scenario: Closed window after frames

- **WHEN** the shared window closes under Wayland after frames have been delivered
- **THEN** local sharing ends
- **AND** the call stays connected
- **AND** no error notice appears

#### Scenario: Permanent error before the first frame

- **WHEN** a permanent capture error arrives after the user confirmed a Wayland source and before any frame
- **THEN** the user sees a notice that the system stopped the capture
- **AND** the call stays connected

### Requirement: A macOS permanent capture error stays a notice

A permanent capture error during an active macOS share after frames MUST show a notice. macOS, Windows, and plain X11 MUST keep their current failure notices.

#### Scenario: macOS permanent error stays visible

- **WHEN** a permanent capture error arrives during an active macOS share after frames
- **THEN** the user sees a notice that the system stopped the capture
