# fork-delivery Specification

## Purpose

Entwicklung und Releases laufen auf dem Fork `d0dg3r/rusty-teams`. Upstream `danieldaeschle/rusty-teams` erhält nur gezielte kleine PRs. Alltagskomits und Fork-Tags landen nie versehentlich auf Upstream.

## Requirements

### Requirement: Everyday work pushes to fork

Everyday commits and feature branches SHALL be pushed to the `fork` remote. The `origin` remote MUST NOT be the push target for routine development.

#### Scenario: Feature branch tracks fork

- **WHEN** a developer pushes the current product branch
- **THEN** the remote is `fork` (`d0dg3r/rusty-teams`)
- **AND** `origin` is not updated by that push

### Requirement: Upstream contributions are thin slices

Pull requests to Upstream SHALL start from current `origin/main` and cover one topic. The whole fork product line MUST NOT be opened as a single Upstream PR.

#### Scenario: Mic fix can be an Upstream PR

- **WHEN** only the Linux mic behaviour is contributed Upstream
- **THEN** the PR branch is based on current `origin/main`
- **AND** unrelated fork features (agents, OpenSpec baseline, …) are not included

### Requirement: Fork releases use distinct tags

Releases published for this product line SHALL be GitHub releases on the fork. Tag names MUST NOT reuse Upstream `vX.Y.Z` when the content differs; prefer a Joe namespace such as `v0.3.0-joe.1`.

#### Scenario: Tag on fork only

- **WHEN** a release tag is created for the fork product line
- **THEN** the tag is pushed to `fork`
- **AND** Upstream is not tagged with that release as a side effect

### Requirement: Local install matches the fork build

Installing for daily use on Linux SHALL place the built binary at `/usr/local/bin/rusty-teams` (with `teams` as a symlink when used).

#### Scenario: Install after release build

- **WHEN** a release binary is installed for local use
- **THEN** `/usr/local/bin/rusty-teams` is the binary that runs
- **AND** launching `teams` resolves to that same binary when the symlink is present
