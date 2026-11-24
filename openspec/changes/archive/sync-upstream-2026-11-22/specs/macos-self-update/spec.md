# Spec Delta

## ADDED Requirements

### Requirement: macOS does not replace its own binary

On macOS the app MUST NOT download a release binary and swap it in place. The install artifact SHALL be the universal `.app` bundle. A newer version is taken by replacing that bundle.

#### Scenario: Running from an installed app

- **WHEN** the app is running from a macOS `.app` bundle
- **THEN** Settings does not offer an in-app download that replaces the executable inside that bundle

#### Scenario: Release asset

- **WHEN** a release is published
- **THEN** the macOS asset is the `.app` zip
- **AND** the release does not include a bare universal Mach-O for self-update
