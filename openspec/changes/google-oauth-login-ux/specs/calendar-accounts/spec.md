# Spec Delta

## ADDED Requirements

### Requirement: Project Desktop client for Connect Google

Official release builds SHALL include the project Google OAuth Desktop client so the user can connect Google Calendar without exporting client credentials in a shell. Runtime environment variables MUST still override the baked client for developers. Connect MUST open the authorize URL in the user's preferred external browser (or the system default when none is set). User tokens MUST stay on the device until disconnect.

#### Scenario: Connect from a Dock or Start Menu install

- **WHEN** the user runs an official release build and chooses Connect Google
- **THEN** Google sign-in for calendar scopes completes without requiring `TEAMS_GOOGLE_CLIENT_*` in the process environment
- **AND** the connected account appears among calendar accounts

#### Scenario: Developer override without rebuild

- **WHEN** a developer sets `TEAMS_GOOGLE_CLIENT_ID` (and optionally `TEAMS_GOOGLE_CLIENT_SECRET`) in the environment before starting a local build
- **THEN** that client is used instead of any baked-in values
- **AND** Connect still stores tokens only on the device

#### Scenario: Reconnect after disconnect

- **WHEN** the user disconnects Google and later chooses Connect Google again on the same release build
- **THEN** the same one-click flow runs again
- **AND** no client-id field is required in Settings
