# Spec Delta

## ADDED Requirements

### Requirement: Quality settings survive call-window sync
After merging upstream call-window layout, the camera video quality setting (Auto / 720p / 1080p) SHALL still control capture ceiling and stage receive budgets as in the baseline camera-video-quality spec.

#### Scenario: Quality still applies in call window
- **WHEN** the user sets camera quality to 720p and joins a call in the dedicated call window
- **THEN** capture stays at or below 720p and stage receive budgets follow the 720p ceiling
