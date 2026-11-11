# agent-providers Specification

## Purpose

Die Fork-App erkennt lokale Agent-CLIs, lässt Profile und Aktionen in den Einstellungen pflegen und startet Agent-Läufe inkl. Chat-Runs aus der UI.

## Requirements

### Requirement: Installed CLIs are discoverable

The app SHALL scan for known agent CLIs on the host (including user bin directories that a desktop session often omits from PATH) and offer them as installable profiles.

#### Scenario: Claude on PATH or user bin

- **WHEN** a `claude` binary exists on PATH or under `~/.local/bin`
- **THEN** the agents settings can offer it as an installable host profile

#### Scenario: Cursor agent binary aliases

- **WHEN** `cursor-agent` or `agent` is available as the Cursor CLI
- **THEN** it appears as a Cursor host profile candidate

### Requirement: Agent settings persist profiles and actions

Agent settings SHALL store profiles, actions, recent working directories, and which agent is used for «write with», and SHALL reject unknown placeholders and empty commands.

#### Scenario: Invalid action is rejected

- **WHEN** an action references an agent id that is not in the profile list
- **THEN** settings validation reports that problem
- **AND** the invalid configuration is not treated as healthy

#### Scenario: Write-with can target a chat profile

- **WHEN** the user picks a chat-capable agent for «write with»
- **THEN** that choice is stored in agent settings
- **AND** empty write-with means Microsoft Copilot

### Requirement: Chat and task runs are started from the app

The user SHALL be able to start agent runs and chat runs from the app against a configured profile, with working-directory context remembered per agent.

#### Scenario: Recent working directories are remembered

- **WHEN** the user runs an agent with a working directory
- **THEN** that directory is kept in the recent list for that agent (capped)
- **AND** it can be chosen again later without retyping
