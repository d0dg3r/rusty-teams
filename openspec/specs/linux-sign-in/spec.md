# linux-sign-in Specification

## Purpose

Auf Linux meldet sich die App über eine Chrome-Instanz mit Remote-Debugging am Microsoft-Konto an, startet aus dem lokalen Cache und hält genau eine laufende Instanz.

## Requirements

### Requirement: Sign-in uses Chrome on a debug port

On Linux the app SHALL connect to a Chrome started with a remote debugging port and already signed in to Teams (or Outlook on the web when the tenant needs it). The app MUST NOT claim a finished built-in login that replaces Chrome.

#### Scenario: Debug endpoint is used

- **WHEN** the user starts the app with a Chrome listening on the configured debug endpoint
- **THEN** the app attaches to that Chrome and can open Teams sessions

#### Scenario: Missing Chrome is not silent success

- **WHEN** no Chrome answers on the debug endpoint
- **THEN** the app does not pretend the user is signed in to Teams

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
