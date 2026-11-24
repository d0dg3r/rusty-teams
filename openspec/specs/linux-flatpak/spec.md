# linux-flatpak Specification

## Purpose

Define how the app behaves when it runs as a Flatpak: packaging owns install and updates, desktop identity matches the Flatpak app id, and sign-in Chrome is available inside the sandbox without host overrides.

## Requirements

### Requirement: No XDG self-install under Flatpak

When the process runs with `FLATPAK_ID` set, the app MUST NOT offer to install itself into the user XDG data folder, and Settings MUST NOT offer Install, Replace, or Remove for that XDG copy.

#### Scenario: Cold start does not ask to install

- **WHEN** the user starts the Flatpak and has never used the XDG self-install path
- **THEN** no dialog offers to install the binary under `~/.local/share/rusty-teams`

#### Scenario: Settings hides package install actions

- **WHEN** the user opens Settings > General while running as Flatpak
- **THEN** Install, Replace, and Remove for the XDG copy are not offered

### Requirement: No GitHub self-update under Flatpak

When the process runs with `FLATPAK_ID` set, the app MUST NOT check GitHub for a replacement binary, MUST NOT download or swap a release file, and MUST NOT offer the release-update dialog, its periodic check, Automatic updates, or Check now. Packaging owns updates.

#### Scenario: Automatic updates stay off for the package

- **WHEN** the Flatpak is running
- **THEN** the app does not download or propose a GitHub release binary as a self-update
- **AND** it does not open a dialog that a newer GitHub release exists

#### Scenario: Settings hide the release check

- **WHEN** the user opens Settings while running as Flatpak
- **THEN** the update switch and Check now are not offered

### Requirement: Desktop entry id matches the Flatpak app id

When `FLATPAK_ID` is set, desktop notifications and the tray StatusNotifierItem MUST identify the desktop entry with that Flatpak app id so the shell pairs toasts and tray icons with the exported `.desktop` file.

#### Scenario: Notification desktop-entry hint

- **WHEN** the Flatpak shows a desktop notification
- **THEN** the notification’s desktop-entry hint is the Flatpak app id

#### Scenario: Tray desktop identity

- **WHEN** the Flatpak shows a tray icon
- **THEN** the tray item’s desktop identity is the Flatpak app id

### Requirement: Managed Chrome available on the sandbox PATH

The Flatpak package SHALL provide a `google-chrome` command on the sandbox PATH that launches the packaged Chromium browser with the arguments the app already uses for managed sign-in (remote debugging port and profile under the Flatpak XDG data folder). The user MUST NOT need Flatseal host filesystem or host spawn permissions for that browser.

#### Scenario: Default Flatpak start finds Chrome

- **WHEN** the user starts the Flatpak without `--endpoint` and Chrome extra-data is installed
- **THEN** the app finds `google-chrome` on PATH and starts the managed sign-in browser inside the sandbox
