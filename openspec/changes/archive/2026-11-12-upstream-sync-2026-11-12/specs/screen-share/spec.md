# Spec Delta

## ADDED Requirements

### Requirement: Screen share start and stop reliability
Starting screen share SHALL deliver a picture on Windows, and stopping share SHALL complete without hanging the call UI.

#### Scenario: Windows share shows a picture
- **WHEN** the user starts screen share on Windows in a connected call
- **THEN** the remote side receives a share picture

#### Scenario: Stop never hangs
- **WHEN** the user stops screen share
- **THEN** the stop completes and the call UI remains responsive

### Requirement: Call windows remain screenshot-visible
Call, mini and gallery windows SHALL remain visible to the OS screenshot/capture path after share or overlay changes that previously hid them.

#### Scenario: Screenshot includes call windows
- **WHEN** the user captures the screen while a call window is open
- **THEN** the call window content is included in the capture where the OS allows it
