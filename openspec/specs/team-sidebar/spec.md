# team-sidebar Specification

## Purpose

A channel stays under its team, and the control to show fewer channels is the last row of that team.

## Requirements

### Requirement: A new channel is not a group chat

A channel thread SHALL appear under its team. It MUST NOT appear as a group chat. When a message arrives for a channel the app does not know yet, the app SHALL refresh the team list so the channel shows under its team, at most once a minute. A team refresh SHALL drop chat rows whose id is a channel id.

#### Scenario: Message in an unknown channel

- **WHEN** a message arrives for a channel that is not in the local team list
- **THEN** the channel shows under its team and does not show as a group chat

#### Scenario: Known channel stays put

- **WHEN** a message arrives for a channel the app already lists under its team
- **THEN** the channel stays under that team and no extra group chat row appears

### Requirement: See fewer channels is the last row

When a team shows extra channels, the "See fewer channels" control SHALL sit below those channels.

#### Scenario: Revealed channels sit above the toggle

- **WHEN** the user has expanded the hidden channels of a team
- **THEN** those channels are listed and "See fewer channels" is the last row of that team
