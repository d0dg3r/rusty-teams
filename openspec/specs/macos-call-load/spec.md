# macos-call-load Specification

## Purpose

Show, on macOS, which thread used CPU during a call, which camera effects were on, and how warm the machine was, so a later capture change can follow the measured hot path.

## Requirements

### Requirement: macOS call report records host load every two seconds

On macOS, while a call is connected and call reports are enabled, the call report MUST add a host-load entry about every two seconds. Each entry MUST name every thread that used CPU since the previous entry, or since the call started for the first entry, together with that CPU time. Each entry MUST state whether background blur, standout, auto framing, brightness, and soft focus are on. Each entry MUST state the process thermal state as one of nominal, fair, serious, or critical. Linux and Windows call reports MUST NOT add these host-load entries.

#### Scenario: Camera-on minute names the camera thread

- **WHEN** a macOS call runs for at least four seconds with the local camera sending and no camera effect enabled
- **THEN** the call report contains at least two host-load entries
- **AND** each entry names the threads that used CPU in that interval
- **AND** each entry states that blur, standout, auto framing, brightness, and soft focus are off
- **AND** each entry states a thermal state

#### Scenario: Other platforms stay quiet

- **WHEN** a call runs on Linux or Windows with call reports enabled
- **THEN** the call report has no host-load entry
