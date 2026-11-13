# fork-delivery Specification

## Purpose

Development and releases run on the Forgejo SoT `devops-geek/rusty-teams` (`origin`). GitHub `d0dg3r/rusty-teams` (`github`) is an offsite mirror. Upstream `danieldaeschle/rusty-teams` (`upstream`) receives only targeted small PRs. Everyday commits and fork tags must never land on upstream by mistake.

## Requirements

### Requirement: Everyday work pushes to Forgejo SoT

Everyday commits and feature branches SHALL be pushed to the `origin` remote (`forgejo.lan/devops-geek/rusty-teams`). The `upstream` remote MUST NOT be the push target for routine development. The `github` remote MUST NOT be used as the everyday SoT push target.

#### Scenario: Feature branch tracks origin

- **WHEN** a developer pushes the current product branch
- **THEN** the remote is `origin` (`devops-geek/rusty-teams` on Forgejo)
- **AND** `upstream` is not updated by that push

### Requirement: Upstream contributions are thin slices

Pull requests to Upstream SHALL start from current `upstream/main` and cover one topic. The whole fork product line MUST NOT be opened as a single Upstream PR.

#### Scenario: Mic fix can be an Upstream PR

- **WHEN** only the Linux mic behaviour is contributed Upstream
- **THEN** the PR branch is based on current `upstream/main`
- **AND** unrelated fork features (agents, OpenSpec baseline, …) are not included

### Requirement: Fork releases use distinct tags

Releases published for this product line SHALL be tags and releases on Forgejo (`devops-geek/rusty-teams`), mirrored to GitHub when configured. Tag names MUST NOT reuse Upstream `vX.Y.Z` when the content differs; prefer a Joe namespace such as `v0.3.0-joe.1`.

#### Scenario: Tag on Forgejo SoT only

- **WHEN** a release tag is created for the fork product line
- **THEN** the tag is pushed to `origin` (Forgejo)
- **AND** Upstream is not tagged with that release as a side effect

### Requirement: Local install matches the fork build

Installing for daily use on Linux SHALL place the built binary at `/usr/local/bin/rusty-teams` (with `teams` as a symlink when used).

#### Scenario: Install after release build

- **WHEN** a release binary is installed for local use
- **THEN** `/usr/local/bin/rusty-teams` is the binary that runs
- **AND** launching `teams` resolves to that same binary when the symlink is present
