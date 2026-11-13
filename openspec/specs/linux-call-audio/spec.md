# linux-call-audio Specification

## Purpose

Auf Linux hört die Gegenseite dasselbe Mikrofon wie in Teams im Browser: Auto und Low senden über den Pulse-ADM-Pfad. Music-Mode, Off und Computer-Sound nutzen die Software-Kette. Auflegen darf den Client nicht abstürzen oder hängen lassen.

## Requirements

### Requirement: Auto and Low use the Pulse device track on Linux

With noise suppression Auto or Low and music mode off, the call SHALL send the platform ADM microphone track (Pulse), not a separate silent ALSA default capture.

#### Scenario: Default Auto matches Web Teams input

- **WHEN** the user places a call on Linux with default mic settings (Auto, music mode off)
- **THEN** the remote party hears the Pulse-selected microphone
- **AND** the local user still hears the remote party through Pulse playback

#### Scenario: Low stays on the device track

- **WHEN** the user sets noise suppression to Low
- **THEN** the outgoing track remains the Pulse ADM device track

### Requirement: Music mode, Off and computer sound use the software path

Music mode, noise suppression Off, and sharing computer sound SHALL capture through the software audio path. A named microphone that cannot be resolved for that path MUST fail clearly instead of falling back to an unrelated default device without notice.

#### Scenario: Unresolved named mic does not silently switch

- **WHEN** the software path needs a named input that is not available for capture
- **THEN** capture fails with an error or notice
- **AND** the app does not quietly send a different default mic

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
