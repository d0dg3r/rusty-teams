# Spec Delta

## ADDED Requirements

### Requirement: Channel mention edit succeeds

Editing a channel post to add a mention of that channel SHALL save the post. The edit SHALL NOT fail because the channel mention was sent through a path that cannot write channel messages.

#### Scenario: Add a channel mention

- **WHEN** the user edits a channel post and adds a mention of the channel
- **THEN** the post saves with that channel mention

#### Scenario: Team and tag mentions still save

- **WHEN** the user edits a channel post and adds a team mention or a tag mention
- **THEN** the post saves with that mention
