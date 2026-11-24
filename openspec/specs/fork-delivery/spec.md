# fork-delivery Specification

## Purpose

Development and releases run on the Forgejo SoT `devops-geek/rusty-teams` (`origin`). GitHub `d0dg3r/rusty-teams` (`github`) is an offsite mirror. Upstream `danieldaeschle/rusty-teams` (`upstream`) receives only targeted small PRs. Everyday commits and fork tags must never land on upstream by mistake.

## Requirements

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

### Requirement: Open upstream PR heads live on Forgejo

While a pull request from `d0dg3r/rusty-teams` to `danieldaeschle/rusty-teams` is open, its head branch SHALL exist on Forgejo (`origin`). Before any push to `origin`, `.githooks/pre-push` MUST refuse the push when such a head is absent from Forgejo and is not part of that push, and MUST refuse a push that deletes such a head. The Forgejo push mirror deletes GitHub branches that Forgejo does not have; that deletion closes the upstream pull request.

#### Scenario: Merge to Forgejo does not drop an open upstream PR

- **WHEN** a developer pushes to `origin` while an upstream pull request from `d0dg3r` is open
- **THEN** the head branch already exists on Forgejo or is included in the same push
- **AND** the pre-push hook rejects the push when the head is missing or would be deleted

#### Scenario: GitHub fork is not where the PR head is created

- **WHEN** a developer prepares an upstream pull request
- **THEN** the head is pushed to `origin` first
- **AND** the GitHub fork receives that branch only through the Forgejo push mirror

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
