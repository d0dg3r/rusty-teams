# macos-sign-in Specification

## Purpose
Auf macOS startet und verwaltet die App Chrome oder Chromium mit Remote-Debugging und eigenem Profil, meldet sich darüber am Microsoft-Konto an, startet aus dem lokalen Cache und hält genau eine laufende App-Instanz.

## Requirements

### Requirement: App manages Chrome on a debug port

On macOS the app SHALL start Google Chrome or Chromium with a remote debugging port and its own profile under Application Support, keep it headless while signed in, and show the Chrome window when Teams needs a login. With `--endpoint` the app MUST attach to an existing Chrome instead of starting one. The app MUST NOT claim a finished built-in login that replaces Chrome.

#### Scenario: Default start launches managed Chrome

- **WHEN** the user starts the app on macOS without `--endpoint`
- **THEN** the app starts Chrome or Chromium on the debug port with the managed profile
- **AND** can open Teams sessions through that instance

#### Scenario: External endpoint attaches instead

- **WHEN** the user starts with `--endpoint` pointing at a Chrome debug URL
- **THEN** the app attaches to that Chrome and does not start a second managed browser for that session

#### Scenario: Login window shows then returns to background

- **WHEN** Teams requires a sign-in
- **THEN** the managed Chrome window becomes visible for login
- **AND** after a successful Teams session with MSAL cache it returns to the background

### Requirement: Chrome is found in standard locations

On macOS the app SHALL find Chrome or Chromium under `/Applications`, under the user's Applications folder, and on `PATH` before reporting that no browser is available.

#### Scenario: Chrome under Applications

- **WHEN** Google Chrome is installed under `/Applications` and not necessarily on `PATH`
- **THEN** the app still starts that Chrome for the managed session

### Requirement: Headless user agent is macOS Chrome

When the managed browser runs headless on macOS, the app SHALL send a macOS Chrome user-agent string, not a Windows NT user-agent.

#### Scenario: Headless reports macOS

- **WHEN** the managed Chrome runs headless after sign-in on macOS
- **THEN** its user-agent identifies a macOS Chrome build

### Requirement: Only Chrome owns the debug port kill

When the app stops a process that listens on the managed debug port on macOS, it MUST do so only when that process is Chrome (including the process name `Google Chrome`).

#### Scenario: Non-Chrome listener is left alone

- **WHEN** another process holds the debug port
- **THEN** the app does not kill that process as if it were the managed Chrome

### Requirement: Start from local cache

The app SHALL open from its local cache without blocking the first paint on a full network round-trip for the sidebar.

#### Scenario: Cached chats appear without a spinner wall

- **WHEN** the user has used the app before and starts it again on macOS
- **THEN** cached chats and channels are shown from the local store while the session reconnects

### Requirement: Single instance

A second start SHALL bring the existing window to the front instead of opening a second app process for everyday use.

#### Scenario: Second launch focuses the first window

- **WHEN** the app is already running on macOS and the user launches it again
- **THEN** the existing window is raised
- **AND** a second full client does not stay in the foreground as a duplicate
