# Spec Delta

## ADDED Requirements

### Requirement: Reads proceed during a long write

A long local write, including saving messages, MUST NOT block reads of chats, messages, and sidebar data. The open window SHALL stay usable while that write runs.

#### Scenario: Message save does not freeze the window

- **WHEN** the app is writing a large batch of messages
- **THEN** the open chat and the sidebar still read their current data without waiting for that write to finish
