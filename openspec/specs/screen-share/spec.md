# screen-share Specification

## Purpose

Local screen or window sharing in a call: on Wayland and macOS via the system dialog; on Windows and plain X11 via the in-app source list.

## Requirements

### Requirement: Wayland opens the desktop dialog

In a connected call under Wayland the app MUST open the desktop ScreenCast dialog. It MUST NOT list sources itself with thumbnails.

#### Scenario: Entire screen

- **WHEN** the user chooses to share the entire screen under Wayland
- **THEN** the desktop opens a dialog for monitors only
- **AND** the app does not show its own thumbnail source list

#### Scenario: A window

- **WHEN** the user chooses to share a window under Wayland
- **THEN** the desktop opens a dialog for windows only

#### Scenario: XWayland alongside

- **WHEN** `WAYLAND_DISPLAY` is set and an X11 `DISPLAY` also exists
- **THEN** share opens the same desktop dialog as without that `DISPLAY`

#### Scenario: KDE, GNOME, and Hyprland

- **WHEN** the user picks the same share kind on KDE, GNOME, or Hyprland
- **THEN** that desktop’s dialog appears for monitors or windows
- **AND** the app does not show its own window list on any of the three

### Requirement: Wayland share needs no prefilled source list

In a connected call under Wayland the user MUST reach both share actions without the app enumerating screens or windows first.

#### Scenario: Connected without a prefilled list

- **WHEN** a call is connected and the session is Wayland
- **THEN** the user can choose entire screen and a window
- **AND** the share control is not disabled merely because no source list exists

### Requirement: Existing share options remain

The Wayland share menu MUST still offer computer sound, motion optimization, and showing the local person over content.

#### Scenario: Menu before the dialog

- **WHEN** the user opens the share menu under Wayland
- **THEN** «Include computer sound», «Optimize for motion», and «Show me over my content» are available
- **AND** beside them are the two actions for screen and window

### Requirement: Confirmed share stays controllable in the app

After the user confirms a source in the desktop dialog, the app MUST show local sharing and the user MUST be able to stop it without leaving the call.

#### Scenario: Banner and stop

- **WHEN** the user confirms a source in the desktop dialog
- **THEN** the app shows that local share is active
- **AND** the user can stop sharing while the call continues

### Requirement: Cancel leaves the call alone

If the user cancels the desktop dialog, no share MUST start and the call MUST stay connected.

#### Scenario: Dialog cancelled

- **WHEN** the user cancels the desktop dialog
- **THEN** sharing does not start
- **AND** the call stays connected
- **AND** no error toast appears

### Requirement: Missing portal is visible

If the app cannot open the ScreenCast dialog, it MUST show that clearly in a connected call.

#### Scenario: Portal missing

- **WHEN** the user starts share under Wayland and no ScreenCast portal is available
- **THEN** the user sees a clear notice
- **AND** the control does not look merely like «not connected yet»

### Requirement: Entire screen without our own window

When sharing the entire screen, the app main window MUST NOT remain in the shared picture.

#### Scenario: Main window steps aside

- **WHEN** the user shares the entire screen and the desktop dialog is confirmed
- **THEN** the app main window is not part of the shared picture

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

### Requirement: Screen share start and stop reliability

Starting screen share SHALL deliver a picture on Windows, and stopping share SHALL complete without hanging the call UI.

#### Scenario: Windows share shows a picture

- **WHEN** the user starts screen share on Windows in a connected call
- **THEN** the remote side receives a share picture

#### Scenario: Stop never hangs

- **WHEN** the user stops screen share
- **THEN** the stop completes and the call UI remains responsive

### Requirement: Call windows remain screenshot-visible

Call, mini and gallery windows SHALL remain visible to the OS screenshot/capture path after share or overlay changes that previously hid them.

#### Scenario: Screenshot includes call windows

- **WHEN** the user captures the screen while a call window is open
- **THEN** the call window content is included in the capture where the OS allows it

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
