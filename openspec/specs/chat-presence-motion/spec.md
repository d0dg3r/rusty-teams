# chat-presence-motion Specification

## Purpose

Chat shows message appear animation, typing in the thread, out-of-office notice, and a startup splash with progress.

## Requirements

### Requirement: Message appear animation
New messages SHALL animate into the conversation feed when they arrive.

#### Scenario: Incoming message motion
- **WHEN** a new message is appended to the open chat
- **THEN** it appears with the chat appear animation rather than popping in without motion

### Requirement: Typing indicator in chat
The typing indicator SHALL render as part of the chat conversation UI.

#### Scenario: Peer typing
- **WHEN** a peer is typing in the open chat
- **THEN** the typing indicator is visible in the conversation area

### Requirement: Out of office notice
When the peer has an out-of-office notice, the chat SHALL show it above the composer.

#### Scenario: OOO above composer
- **WHEN** the active chat has an out-of-office notice for the peer
- **THEN** the notice is shown above the composer

### Requirement: Start-up splash
On start-up the application SHALL show a splash with a loading bar and what is currently loading.

#### Scenario: Splash while loading
- **WHEN** the app is starting and still loading session or initial data
- **THEN** a splash with progress and a loading label is visible until ready
