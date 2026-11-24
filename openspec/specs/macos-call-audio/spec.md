# macos-call-audio Specification

## Purpose
On macOS the remote party hears the same microphone as Teams in the browser: Auto and Low send over the CoreAudio ADM path. Music Mode, Off, and computer sound use the software chain. Camera preview and send use the system camera. Hanging up must not crash the client.

## Requirements

### Requirement: Auto and Low use the CoreAudio device track on macOS

With noise suppression Auto or Low and music mode off, the call SHALL send the platform ADM microphone track (CoreAudio), not a separate silent default capture.

#### Scenario: Default Auto matches Web Teams input

- **WHEN** the user places a call on macOS with default mic settings (Auto, music mode off)
- **THEN** the remote party hears the CoreAudio-selected microphone
- **AND** the local user still hears the remote party through CoreAudio playback

#### Scenario: Low stays on the device track

- **WHEN** the user sets noise suppression to Low on macOS
- **THEN** the outgoing track remains the CoreAudio ADM device track

### Requirement: Music mode, Off and computer sound use the software path

Music mode, noise suppression Off, and sharing computer sound SHALL capture through the software audio path. A named microphone that cannot be resolved for that path MUST fail clearly instead of falling back to an unrelated default device without notice.

#### Scenario: Unresolved named mic does not silently switch

- **WHEN** the software path needs a named input that is not available for capture on macOS
- **THEN** capture fails with an error or notice
- **AND** the app does not quietly send a different default mic

### Requirement: Hangup tears down audio without hanging the call task

Ending a call SHALL stop software-audio workers without joining a blocked feeder on the Tokio worker, and SHALL close the far-end sink without racing mid-callback in a way that aborts the whole app.

#### Scenario: Hangup after a software-audio call

- **WHEN** a call that used software audio ends on macOS
- **THEN** the app returns to the idle call UI
- **AND** the process stays alive

### Requirement: Camera preview and send use the system camera

On macOS, camera preview and outbound camera video SHALL use the system camera devices. The packaged `.app` MUST carry microphone, camera and screen-capture usage descriptions so the system can show the permission dialogs.

#### Scenario: Camera on in a call

- **WHEN** the user turns the camera on during a connected call on macOS
- **THEN** the local preview shows the system camera
- **AND** the remote party can receive that camera video once permissions allow it

#### Scenario: Bundle carries usage strings

- **WHEN** the distributed macOS `.app` is inspected
- **THEN** it declares microphone, camera and screen-capture usage descriptions

### Requirement: Only Low uses the classical noise-suppression track

On the device track, Low SHALL publish the track with classical noise suppression. Auto, Off, and music mode SHALL publish the track without that stage. A failed software-path start MUST NOT restore the classical noise-suppression track for Off or music mode.

#### Scenario: Music mode does not restore noise suppression

- **WHEN** music mode is on and the software path cannot start
- **THEN** the restored device track is the track without classical noise suppression

### Requirement: A named microphone matches the capture name

A named input on the software path SHALL match a capture device when the names are equal ignoring ASCII case, or when either name contains the other. cpal names can differ from the CoreAudio description. An empty target SHALL NOT match. An unmatched name SHALL fail the capture with an error or the existing notice and MUST NOT silently capture a different microphone.

#### Scenario: A shorter description matches a longer capture name

- **WHEN** the requested name is contained in a longer capture-device name
- **THEN** that capture device is selected

### Requirement: Computer sound falls back to the default microphone

While sharing computer sound, a failed named microphone SHALL fall back to the default microphone and show that notice. Silence is used only when the default microphone also fails.

#### Scenario: The default microphone opens

- **WHEN** the named microphone fails and the default microphone starts
- **THEN** the call uses the default microphone and shows the fallback notice

### Requirement: A device switch counts when the index is selected

Selecting an input or output SHALL be reported as applied when the device index is selected, even if recording or playout does not start on that attempt. A single failed start MUST NOT leave the previous device marked as current.

#### Scenario: Start fails once

- **WHEN** the device index is accepted and recording or playout does not start
- **THEN** the selection is still reported as applied
