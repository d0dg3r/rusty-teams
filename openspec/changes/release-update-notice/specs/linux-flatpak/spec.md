## MODIFIED Requirements

### Requirement: No GitHub self-update under Flatpak

When the process runs with `FLATPAK_ID` set, the app MUST NOT check GitHub for a replacement binary, MUST NOT download or swap a release file, and MUST NOT offer the release-update dialog, its periodic check, Automatic updates, or Check now. Packaging owns updates.

#### Scenario: Automatic updates stay off for the package

- **WHEN** the Flatpak is running
- **THEN** the app does not download or propose a GitHub release binary as a self-update
- **AND** it does not open a dialog that a newer GitHub release exists

#### Scenario: Settings hide the release check

- **WHEN** the user opens Settings while running as Flatpak
- **THEN** the update switch and Check now are not offered
