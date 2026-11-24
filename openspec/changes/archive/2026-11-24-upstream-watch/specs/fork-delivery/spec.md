## ADDED Requirements

### Requirement: Upstream movement is reported

When Upstream `main` (`danieldaeschle/rusty-teams`) contains commits that Forgejo `main` does not have, the fork SHALL surface that fact without requiring a manual fetch. A weekday automated watch on Forgejo MUST open or update a single open issue that lists those commits (date, short hash, subject). When Upstream is not ahead, the watch MUST exit without creating an issue. The watch MUST NOT merge Upstream into Forgejo `main`.

#### Scenario: Upstream is ahead

- **WHEN** Upstream `main` has commits not present on Forgejo `main`
- **THEN** exactly one open issue reports that Upstream is ahead
- **AND** the issue body includes a commit list with date, short hash, and subject
- **AND** no second open issue for the same condition is created

#### Scenario: Already in sync

- **WHEN** Forgejo `main` already contains every commit on Upstream `main`
- **THEN** the watch completes without creating an issue

#### Scenario: Watch never merges

- **WHEN** the watch detects Upstream is ahead
- **THEN** Forgejo `main` is left unchanged by the watch
- **AND** a human merges Upstream into the product branch at a chosen time

### Requirement: Local Upstream status matches the watch

A local script in the repo SHALL report whether Upstream `main` is ahead of Forgejo `main` (or the current branch's merge-base comparison against the configured Upstream remote) with the same commit list shape as the watch issue when ahead, or a clear in-sync message when not.

#### Scenario: Local status when ahead

- **WHEN** a developer runs the Upstream status script and Upstream is ahead
- **THEN** the script prints the ahead commit list and exits successfully

#### Scenario: Local status when in sync

- **WHEN** a developer runs the Upstream status script and Upstream is not ahead
- **THEN** the script prints that the fork is in sync and exits successfully

## MODIFIED Requirements

### Requirement: Everyday work pushes to Forgejo SoT

Everyday commits and feature branches SHALL be pushed to the `origin` remote (`forgejo.lan/devops-geek/rusty-teams`). The durable product branch for everyday work, OpenSpec, CI, and releases SHALL be Forgejo `main`. The `upstream` remote MUST NOT be the push target for routine development. The `github` remote MUST NOT be used as a work remote: no pushes, no branches created there, no commits authored against it. `.githooks/pre-push` (installed via `scripts/install-git-hooks.sh`) MUST reject pushes whose URL is `d0dg3r/rusty-teams` and pushes whose URL is `danieldaeschle/rusty-teams`. Taking Upstream into the product line SHALL remain a conscious merge into Forgejo `main` after the Upstream-ahead notice (or an equivalent local check), not an automatic merge by the watch.

#### Scenario: Feature branch tracks origin

- **WHEN** a developer pushes the current product branch
- **THEN** the remote is `origin` (`devops-geek/rusty-teams` on Forgejo)
- **AND** `upstream` is not updated by that push

#### Scenario: Product branch stays main

- **WHEN** everyday product work is integrated
- **THEN** it lands on Forgejo `main`
- **AND** a second everyday product branch is not required for Upstream visibility
