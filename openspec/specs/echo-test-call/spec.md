# echo-test-call Specification

## Purpose

Make the built-in Echo / audio test call either connect with the Echo bot or end with a clear failure instead of sitting forever in a connecting state.

## Requirements

### Requirement: Echo test call connects when the bot joins

When the user starts the Echo / audio test call and the Echo bot is successfully added, the call SHALL leave the connecting state and become connected so the user can hear the echo of their microphone.

#### Scenario: Successful Echo test call

- **WHEN** the user starts the Echo test call and the service accepts the Echo bot
- **THEN** the call reaches a connected state
- **AND** the user can hear their own audio echoed back when a microphone is available

### Requirement: Echo bot add failure ends the call with a notice

When adding the Echo bot fails (including a synchronous HTTP error before any roster callback), the client SHALL end the test call promptly and show a user-visible notice. The call MUST NOT remain in connecting indefinitely waiting for a bot that will never join.

#### Scenario: Bot add HTTP failure ends connecting

- **WHEN** the Echo bot add request fails while the test call is connecting
- **THEN** the call ends without waiting for a roster join
- **AND** the user sees a notice that the test call could not start

### Requirement: Echo bot add failures are recorded for diagnosis

When the Echo bot add fails, the call diagnostics SHALL record the failure reason from the service response (at least status and a short body excerpt) so an operator can see why the add was rejected.

#### Scenario: Timeline includes the add failure reason

- **WHEN** the Echo bot add returns an error response
- **THEN** the call timeline or call report includes that status and a short body excerpt
