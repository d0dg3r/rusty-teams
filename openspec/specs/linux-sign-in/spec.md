# linux-sign-in Specification

## Purpose

Auf Linux startet und verwaltet die App Chrome/Chromium mit Remote-Debugging (eigener Profilordner), meldet sich darüber am Microsoft-Konto an, startet aus dem lokalen Cache und hält genau eine laufende Instanz.

## Requirements

### Requirement: App manages Chrome on a debug port

On Linux the app SHALL start Google Chrome or Chromium with a remote debugging port and its own profile under the XDG data folder, keep it headless while signed in, and show the Chrome window when Teams needs a login. With `--endpoint` the app MUST attach to an existing Chrome instead of starting one. The app MUST NOT claim a finished built-in login that replaces Chrome.

#### Scenario: Default start launches managed Chrome

- **WHEN** the user starts the app on Linux without `--endpoint`
- **THEN** the app starts Chrome or Chromium on the debug port with the managed profile
- **AND** can open Teams sessions through that instance

#### Scenario: External endpoint attaches instead

- **WHEN** the user starts with `--endpoint` pointing at a Chrome debug URL
- **THEN** the app attaches to that Chrome and does not start a second managed browser for that session

#### Scenario: Login window shows then returns to background

- **WHEN** Teams requires a sign-in
- **THEN** the managed Chrome window becomes visible for login
- **AND** after a successful Teams session with MSAL cache it returns to the background

### Requirement: Start from local cache

The app SHALL open from its local cache without blocking the first paint on a full network round-trip for the sidebar.

#### Scenario: Cached chats appear without a spinner wall

- **WHEN** the user has used the app before and starts it again
- **THEN** cached chats and channels are shown from the local store while the session reconnects

### Requirement: Single instance

A second start SHALL bring the existing window to the front instead of opening a second app process for everyday use.

#### Scenario: Second launch focuses the first window

- **WHEN** the app is already running and the user launches it again
- **THEN** the existing window is raised
- **AND** a second full client does not stay in the foreground as a duplicate
