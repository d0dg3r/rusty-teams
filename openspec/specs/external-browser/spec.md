# external-browser Specification

## Purpose

Let the user pick which installed browser opens external http(s) links and Google OAuth authorize pages, without changing the managed Chrome session used for Microsoft Teams sign-in.

## Requirements

### Requirement: Preferred browser for external opens

The app SHALL let the user choose a preferred browser for opening external http(s) URLs (including the Google Calendar OAuth authorize URL). When unset, the app MUST use the operating system default handler. Changing the preference MUST NOT replace or reconfigure the managed Teams Chrome profile.

#### Scenario: Google Connect uses preferred browser

- **WHEN** the user has set a preferred external browser and chooses Connect Google
- **THEN** the authorize URL opens in that browser
- **AND** managed Teams Chrome is unchanged

#### Scenario: System default when unset

- **WHEN** no preferred external browser is set and the app opens an http(s) link
- **THEN** the system default browser handles the URL

#### Scenario: Preference survives restart

- **WHEN** the user sets a preferred external browser and restarts the app
- **THEN** the same preference is still selected in Settings
- **AND** subsequent external opens use that browser
