# Spec Delta

## Purpose

Windows call microphone and speaker behaviour: which capture path Auto and Low use, and how a headset that drops and returns comes back into the live call.

## ADDED Requirements

### Requirement: Auto and Low use the Windows device track

With noise suppression Auto or Low and music mode off, a Windows call SHALL send the platform microphone track, not the software capture chain. Auto SHALL run the machine-learning noise suppressor on that track and SHALL NOT also run the platform noise suppressor on the same samples. Low SHALL use only the platform noise suppressor.

#### Scenario: Auto on a full-rate microphone

- **WHEN** noise suppression is Auto, music mode is off, and the selected microphone delivers 48 kHz frames
- **THEN** the outgoing audio is the Windows device track
- **AND** only the machine-learning noise suppressor filters those frames

#### Scenario: Low stays on the device track

- **WHEN** the user sets noise suppression to Low on Windows
- **THEN** the outgoing track remains the Windows device track
- **AND** the machine-learning noise suppressor stays off

#### Scenario: Headset or overload uses one fallback stage

- **WHEN** Auto is on the device track and the microphone is not 48 kHz, the model is not ready yet, or the CPU budget is exceeded
- **THEN** that frame is filtered by a single platform noise-suppression stage
- **AND** the machine-learning suppressor and the platform suppressor do not both run on the same frame

### Requirement: Music mode and Off stay on the software chain

Music mode, noise suppression Off, and sharing computer sound SHALL capture through the software audio path on Windows.

#### Scenario: Music mode

- **WHEN** music mode is on
- **THEN** the outgoing microphone is the software capture chain
- **AND** the device-track noise hook stays off

### Requirement: A returning headset restarts the live audio

If the endpoint that is already in the call changes state or reconnects inside the device-change quiet period, the call SHALL restart capture or playout on that same endpoint. A change of the console default device and a change of the communications default device SHALL both count as a device change.

#### Scenario: Bluetooth headset drops and returns

- **WHEN** the active headset disconnects and reconnects before the quiet period ends
- **THEN** the call restarts the affected direction on that headset
- **AND** the switch counts as done only when capture or playout actually starts, including the one retry

#### Scenario: Restart still fails

- **WHEN** the headset returns and capture or playout still fails to start after one retry
- **THEN** the device switch is reported as failed

#### Scenario: A different device is chosen

- **WHEN** the selected device disappears and another device is the fallback
- **THEN** the call switches to that fallback
- **AND** the user sees a notice that the previous device disconnected
