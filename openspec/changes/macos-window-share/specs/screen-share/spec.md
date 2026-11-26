## ADDED Requirements

### Requirement: macOS window share uses the system window picker

On macOS, choosing to share a window MUST open the ScreenCaptureKit window picker. The app MUST NOT start a window share without that picker. Cancelling the picker MUST leave the call connected and MUST NOT show an error toast.

#### Scenario: Window picker opens

- **WHEN** the user chooses to share a window during a connected call on macOS
- **THEN** the system window picker opens

#### Scenario: Cancel leaves the call

- **WHEN** the user cancels the window picker before any frame
- **THEN** sharing does not start
- **AND** the call stays connected
- **AND** no error toast appears

### Requirement: A vanished shared source ends the share

When the shared window or screen disappears during an active macOS share, the app MUST stop the share and MUST show a notice that the source is no longer available. The call MUST stay connected.

#### Scenario: Shared window closes

- **WHEN** the user is sharing a window on macOS and that window closes
- **THEN** the share ends
- **AND** the user sees a notice that the source is gone
- **AND** the call stays connected
