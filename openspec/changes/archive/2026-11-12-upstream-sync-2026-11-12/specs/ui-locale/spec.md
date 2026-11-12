# Spec Delta

## ADDED Requirements

### Requirement: New upstream chrome uses locale catalog
New user-visible strings introduced by the upstream sync (call toolbar, splash, manage team, out-of-office notice, MCP review prompts) SHALL go through the UI locale catalog with English fallback for missing keys.

#### Scenario: German UI covers new chrome
- **WHEN** the UI language is German and the user opens splash, manage team, or a chat with an out-of-office notice
- **THEN** those surfaces show German catalog strings when keys exist, otherwise English fallback
