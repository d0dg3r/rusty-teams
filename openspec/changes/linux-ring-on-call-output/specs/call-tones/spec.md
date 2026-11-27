## MODIFIED Requirements

### Requirement: Call tones follow the selected output device

When the user has selected a call output device, call tones SHALL play on that device when it is available. On Linux the saved key is a Pulse sink description or name, and that sink SHALL count as available when Pulse lists a sink with the same description or name, ignoring ASCII case and a single leading `default:` prefix. A Game sink MUST NOT be treated as a match for a Chat key, or the reverse. When no device is selected, Pulse cannot be asked, or the selected device cannot be opened, tones SHALL play on the system default output instead of failing silently for that reason alone. A missing selected device SHALL be noted in diagnostics at most once per distinct key.

#### Scenario: Selected output is used for tones

- **WHEN** a call output device is selected and available
- **THEN** ringtone and ringback play on that device

#### Scenario: A Pulse description matches the saved key

- **WHEN** the saved output key is "Headset Game" or "default: Headset Game" and Pulse lists a sink with that description
- **THEN** ringtone and ringback play on that sink
- **AND** a sink described as "Headset Chat" is not used

#### Scenario: Default output is used when selection is missing

- **WHEN** no call output is selected or the selected device cannot be opened
- **THEN** ringtone and ringback play on the system default output
