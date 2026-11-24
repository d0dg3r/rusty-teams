# linux-call-audio Specification

## Purpose

On Linux the remote party hears the same microphone as Teams in the browser: Auto and Low send over the Pulse ADM path. Auto runs DeepFilterNet plus a speech gate on that capture buffer so background noise stays silent. Music Mode, Off, and computer sound use the software chain. Hanging up must not crash or hang the client.

## Requirements

### Requirement: Auto and Low use the Pulse device track on Linux

With noise suppression Auto or Low and music mode off, the call SHALL send the platform ADM microphone track (Pulse), not a separate silent ALSA default capture. Auto SHALL run DeepFilterNet on that capture path (WebRTC capture post-processor hook) so residual noise is gated without leaving the Pulse track. Low SHALL keep classical WebRTC noise suppression only.

#### Scenario: Default Auto matches Web Teams input

- **WHEN** the user places a call on Linux with default mic settings (Auto, music mode off)
- **THEN** the remote party hears the Pulse-selected microphone
- **AND** the local user still hears the remote party through Pulse playback
- **AND** the capture hook is armed for DeepFilterNet on that device track

#### Scenario: Low stays on the device track

- **WHEN** the user sets noise suppression to Low
- **THEN** the outgoing track remains the Pulse ADM device track
- **AND** the DeepFilterNet capture hook is not armed

### Requirement: Music mode, Off and computer sound use the software path

Music mode, noise suppression Off, and sharing computer sound SHALL capture through the software audio path. A named microphone that cannot be resolved for that path MUST fail clearly instead of falling back to an unrelated default device without notice. While that software path owns the microphone, the DeepFilterNet capture hook SHALL stay disarmed so the model does not run twice.

#### Scenario: Unresolved named mic does not silently switch

- **WHEN** the software path needs a named input that is not available for capture
- **THEN** capture fails with an error or notice
- **AND** the app does not quietly send a different default mic

#### Scenario: Computer sound keeps the capture hook off

- **WHEN** the user shares computer sound with noise suppression Auto
- **THEN** DeepFilterNet runs only in the software mic chain
- **AND** the Pulse capture hook is not armed

### Requirement: Hangup tears down audio without hanging the call task

Ending a call SHALL stop software-audio workers without joining a blocked feeder on the Tokio worker, and SHALL close the far-end sink without racing mid-callback in a way that aborts the whole app.

#### Scenario: Hangup after a software-audio call

- **WHEN** a call that used software audio ends
- **THEN** the app returns to the idle call UI
- **AND** the process stays alive

### Requirement: Diagnostics stay useful during calls

Realtime Pulse playout chatter («requesting data», «will write») MUST NOT fill the diagnostics log to the exclusion of useful call events.

#### Scenario: Diagnostics keep non-frame lines

- **WHEN** a call runs with Pulse playout
- **THEN** those per-frame Pulse lines are not written to the diagnostics log

### Requirement: Only Low uses the classical noise-suppression track

On the device track, Low SHALL publish the track with classical noise suppression. Auto, Off, and music mode SHALL publish the track without that stage. A failed software-path start MUST NOT restore the classical noise-suppression track for Off or music mode.

#### Scenario: Off does not restore noise suppression

- **WHEN** noise suppression is Off or music mode is on and the software path cannot start
- **THEN** the restored device track is the track without classical noise suppression

### Requirement: A named microphone matches the capture name

A named input on the software path SHALL match a capture device when the names are equal ignoring ASCII case, or when either name contains the other. cpal names differ from the Pulse description. An empty target SHALL NOT match. An unmatched name SHALL fail the capture with an error or the existing notice and MUST NOT silently capture a different microphone.

#### Scenario: A Pulse description matches a shorter capture name

- **WHEN** the listed name is "Jabra Speak 750 Mono" and cpal reports "Jabra Speak 750"
- **THEN** that capture device is selected

#### Scenario: Endpoint id is not a capture name

- **WHEN** the software path is asked for a named input whose key is an endpoint id and whose listed name is absent from the capture devices
- **THEN** capture fails with an error or notice

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
