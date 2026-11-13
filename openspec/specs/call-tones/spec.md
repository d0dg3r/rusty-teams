# call-tones Specification

## Purpose

Play ringtone, ringback, and other call tones through the system audio output on Linux and macOS so users hear the same call cues as on Windows.

## Requirements

### Requirement: Incoming ringtone is audible on Linux and macOS

When an incoming call should ring, the client SHALL play the ringtone through the system audio output on Linux and on macOS until the call is answered, declined, or the ring ends.

#### Scenario: Incoming call rings on Linux

- **WHEN** an incoming call arrives on Linux and ringing is required
- **THEN** the user hears the ringtone on the active system output

#### Scenario: Incoming call rings on macOS

- **WHEN** an incoming call arrives on macOS and ringing is required
- **THEN** the user hears the ringtone on the active system output

### Requirement: Outgoing ringback is audible on Linux and macOS

While an outgoing non-meeting call is connecting and ringback is required, the client SHALL play the ringback tone through the system audio output on Linux and on macOS.

#### Scenario: Outgoing call plays ringback on Linux

- **WHEN** the user places an outgoing non-meeting call on Linux that is still connecting
- **THEN** the user hears the ringback tone until the call connects or ends

#### Scenario: Outgoing call plays ringback on macOS

- **WHEN** the user places an outgoing non-meeting call on macOS that is still connecting
- **THEN** the user hears the ringback tone until the call connects or ends

### Requirement: Call tones follow the selected output device

When the user has selected a call output device, call tones SHALL play on that device when it is available. When no device is selected or the selected device cannot be opened, tones SHALL play on the system default output instead of failing silently for that reason alone.

#### Scenario: Selected output is used for tones

- **WHEN** a call output device is selected and available
- **THEN** ringtone and ringback play on that device

#### Scenario: Default output is used when selection is missing

- **WHEN** no call output is selected or the selected device cannot be opened
- **THEN** ringtone and ringback play on the system default output
