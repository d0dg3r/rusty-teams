# Spec Delta

## ADDED Requirements

### Requirement: Accepted one-to-one call shows chat

An accepted one-to-one call SHALL offer the chat with the caller, including when the ring payload has no thread id.

#### Scenario: Ring without a thread id

- **WHEN** the user accepts a one-to-one call whose ring payload has no thread id and a one-to-one chat with that caller exists
- **THEN** the call window shows the chat button for that chat
