# Spec Delta

## Purpose

Calls und Meetings laufen in einem eigenen Fenster mit Teams-ähnlicher Toolbar, Gallery-Paging und Join-Preview.

## ADDED Requirements

### Requirement: Dedicated call window
The application SHALL present an active call or meeting in a dedicated call window rather than only as an in-shell overlay.

#### Scenario: Join opens meeting window
- **WHEN** the user joins a call or meeting
- **THEN** the call UI opens in the meeting/call window including the join preview when applicable

### Requirement: Call toolbar order
The call window SHALL show call controls in a header toolbar ordered like current Teams, with controls centered in the header where that layout applies.

#### Scenario: Controls in header
- **WHEN** a call is connected and the call window is visible
- **THEN** mute, camera, share and related controls appear in the header toolbar in the documented Teams-like order

### Requirement: Gallery paging
In large meetings the gallery SHALL support paging through participants.

#### Scenario: Page through gallery
- **WHEN** more participants are present than fit on one gallery page
- **THEN** the user can page through gallery pages without leaving the call window
