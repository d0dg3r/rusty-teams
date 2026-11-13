# macos-call-audio Specification

## Purpose
Auf macOS hört die Gegenseite dasselbe Mikrofon wie in Teams im Browser: Auto und Low senden über den CoreAudio-ADM-Pfad. Music-Mode, Off und Computer-Sound nutzen die Software-Kette. Kamera-Vorschau und -Senden nutzen die Systemkamera. Auflegen darf den Client nicht abstürzen.

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
