# Spec Delta

## Purpose

A release build tells the user when a newer release of this product line exists and opens that release in the browser. It does not download or replace its own binary.

## ADDED Requirements

### Requirement: Release builds notice a newer release

A build that carries a release tag SHALL look for a newer release of this product line on a schedule and when the user asks. The check SHALL run on Windows, Linux, and macOS. A build without a release tag MUST stay silent and MUST NOT offer an update. The check MUST NOT require a downloadable binary for the current platform. "Not now" MUST hide that version until the next start of the app.

#### Scenario: Newer release opens a dialog

- **WHEN** a release-tagged build finds a newer release and the user has not declined that version in this run
- **THEN** a dialog names the new version and the version that is running

#### Scenario: Dev build stays quiet

- **WHEN** the running build has no release tag
- **THEN** no update dialog appears, including after Check now

#### Scenario: Not now holds for this run

- **WHEN** the user chooses Not now for a version
- **THEN** that version is not offered again until the next start
- **AND** Check now in the same run MAY offer it again

### Requirement: Opening the release does not replace the app

The dialog's primary action SHALL open the release page for that version in the browser and dismiss the dialog for this run. The app MUST NOT download a release file, MUST NOT copy or rename the running executable, and MUST NOT restart itself to finish an update.

#### Scenario: Primary action opens the release page

- **WHEN** the user accepts the update dialog
- **THEN** the browser opens the page for that release
- **AND** the running app is the same binary

#### Scenario: No quiet install

- **WHEN** a newer release exists and the window is idle
- **THEN** the app does not download a binary and does not restart on its own

### Requirement: One update switch on every OS

Settings SHALL offer one switch, on by default, that turns the periodic check on or off, and a Check now action. The same switch and the same wording SHALL appear on Windows, Linux, and macOS. Turning the switch off MUST stop the periodic check and MUST still allow Check now. The setting MUST use one key shared by every OS.

#### Scenario: Switch off skips the periodic check

- **WHEN** the user turns the update switch off and a newer release exists
- **THEN** the periodic check does not open the dialog
- **AND** Check now still reports the newer release

#### Scenario: Same settings on each OS

- **WHEN** the user opens Settings on Windows, Linux, or macOS
- **THEN** the update switch and Check now are present with the same meaning
