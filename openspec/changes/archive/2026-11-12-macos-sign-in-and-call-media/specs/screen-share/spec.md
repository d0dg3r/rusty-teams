# Spec Delta

## ADDED Requirements

### Requirement: macOS opens the ScreenCaptureKit dialog

In a connected call on macOS the app MUST open the ScreenCaptureKit system dialog. It MUST NOT list sources itself with thumbnails.

#### Scenario: Entire screen

- **WHEN** the user chooses to share the entire screen on macOS
- **THEN** the system opens a dialog for monitors
- **AND** the app does not show its own thumbnail source list

#### Scenario: A window

- **WHEN** the user chooses to share a window on macOS
- **THEN** the system opens a dialog for windows

### Requirement: macOS share needs no prefilled source list

In a connected call on macOS the user MUST reach both share actions without the app enumerating screens or windows first.

#### Scenario: Connected without a prefilled list

- **WHEN** a call is connected and the session is macOS
- **THEN** the user can choose entire screen and a window
- **AND** the share control is not disabled merely because no source list exists

### Requirement: Confirmed macOS share stays controllable in the app

After the user confirms a source in the ScreenCaptureKit dialog, the app MUST show local sharing and the user MUST be able to stop it without leaving the call.

#### Scenario: Banner and stop

- **WHEN** the user confirms a source in the ScreenCaptureKit dialog
- **THEN** the app shows that local share is active
- **AND** the user can stop sharing while the call continues

### Requirement: Cancel of the macOS dialog leaves the call alone

If the user cancels the ScreenCaptureKit dialog, no share MUST start and the call MUST stay connected.

#### Scenario: Dialog cancelled

- **WHEN** the user cancels the ScreenCaptureKit dialog
- **THEN** sharing does not start
- **AND** the call stays connected
- **AND** no error toast appears

### Requirement: Missing macOS share is visible

If the app cannot open the ScreenCaptureKit dialog or start share, it MUST show that clearly in a connected call.

#### Scenario: Share unavailable

- **WHEN** the user starts share on macOS and the system dialog is unavailable
- **THEN** the user sees a clear notice
- **AND** the control does not look merely like «not connected yet»

## MODIFIED Requirements

### Requirement: Windows and plain X11 keep the list

On Windows and in an X11 session without Wayland, the share menu MUST offer screens and windows with thumbnails, and choosing a source MUST start share without a desktop portal dialog. On macOS that list behaviour MUST NOT apply; the ScreenCaptureKit dialog applies instead.

#### Scenario: List on Windows

- **WHEN** the user opens share in a connected call on Windows
- **THEN** the menu shows screens and windows with thumbnails
- **AND** choosing a source starts share without a desktop portal dialog

#### Scenario: Plain X11

- **WHEN** the session is X11 and `WAYLAND_DISPLAY` is unset
- **THEN** the menu shows screens and windows with thumbnails
- **AND** choosing a source starts share without a desktop portal dialog

#### Scenario: macOS stays on the system dialog

- **WHEN** the user opens share in a connected call on macOS
- **THEN** the menu shows no thumbnail source list
- **AND** the share action opens the ScreenCaptureKit dialog
