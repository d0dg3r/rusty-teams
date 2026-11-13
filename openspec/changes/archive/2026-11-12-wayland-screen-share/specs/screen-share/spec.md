# Spec Delta

## Purpose

Local screen or window sharing in a call: on Wayland via the desktop dialog; on Windows and plain X11 via the in-app list.

## ADDED Requirements

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

On Windows and in an X11 session without Wayland, the share menu MUST offer screens and windows with thumbnails, and choosing a source MUST start share without a desktop portal dialog.

#### Scenario: List on Windows

- **WHEN** the user opens share in a connected call on Windows
- **THEN** the menu shows screens and windows with thumbnails
- **AND** choosing a source starts share without a desktop portal dialog

#### Scenario: Plain X11

- **WHEN** the session is X11 and `WAYLAND_DISPLAY` is unset
- **THEN** the menu shows screens and windows with thumbnails
- **AND** choosing a source starts share without a desktop portal dialog
