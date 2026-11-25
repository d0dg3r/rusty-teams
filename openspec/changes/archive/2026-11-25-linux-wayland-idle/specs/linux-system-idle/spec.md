# Spec Delta

## Purpose

On a Linux Wayland session, presence uses system-wide input so work in other applications keeps the user Available until five minutes without input.

## ADDED Requirements

### Requirement: Wayland input outside the window counts as activity

On Linux, when a Wayland display is available and the compositor reports idle and resume, presence SHALL treat the latest of in-window input and that system idle time as the last activity. The user SHALL stay Available while that last activity is inside the existing five-minute threshold, including when the pointer and keyboard are in another application. A playing video SHALL NOT by itself reset the idle time when the compositor offers an input-only notification.

#### Scenario: Work in another application stays Available

- **WHEN** the user keeps typing or moving the pointer in another application and does not touch the app window
- **THEN** presence stays Available for as long as that input is inside the five-minute threshold

#### Scenario: Idle after five minutes without input

- **WHEN** five minutes pass with no pointer or keyboard input anywhere the compositor reports
- **THEN** presence becomes Away

#### Scenario: Fresh start is active after system input

- **WHEN** the app has just started and the user has not yet clicked inside its window, but has given input elsewhere in the session
- **THEN** presence is Available

### Requirement: Missing Wayland idle report keeps window-only activity

On Linux, when no Wayland display is set, or the compositor does not offer idle notification, presence SHALL keep using only pointer and keyboard input inside the app window. The five-minute threshold SHALL stay unchanged.

#### Scenario: No Wayland display

- **WHEN** the session has no Wayland display
- **THEN** input outside the app window does not count as activity

#### Scenario: Compositor has no idle notification

- **WHEN** a Wayland display is set and the compositor does not offer idle notification
- **THEN** input outside the app window does not count as activity
