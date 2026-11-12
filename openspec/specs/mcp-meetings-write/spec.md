# mcp-meetings-write Specification

## Purpose

Agents können über MCP Nachrichten und Reaktionen vorschlagen, freie Zeiten finden und Meetings organisieren; Proposals überleben Restarts.

## Requirements

### Requirement: Write and reaction tools
The MCP surface SHALL expose tools for writing a message and adding a reaction, with review-before-send controlled by a setting.

#### Scenario: Review before send
- **WHEN** review-before-send is enabled and an agent requests write_message or add_reaction
- **THEN** the action is presented for human review before it is sent

### Requirement: Meeting organization
Agents SHALL be able to find free times and organize meetings through MCP, including asking for a time window when write-without-review applies.

#### Scenario: Free time and meeting proposal
- **WHEN** an agent requests free times or a meeting organization flow
- **THEN** the system returns candidate windows and can create a meeting proposal for the user

### Requirement: Persistent meeting proposals
Meeting proposals SHALL survive an application restart and invites SHALL carry participant names.

#### Scenario: Restart keeps proposal
- **WHEN** a meeting proposal exists and the app restarts
- **THEN** the proposal remains available and invite payloads still include names
