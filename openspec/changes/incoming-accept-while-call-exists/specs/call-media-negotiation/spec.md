## ADDED Requirements

### Requirement: Incoming 1:1 accept does not wait out ICE gathering

When the user answers an incoming 1:1 call, the client SHALL put already gathered candidates into the answer and SHALL post acceptance without waiting for the full ICE gather cap. Gathering that is already settled, including a UDP relay plus its short settle, SHALL be included. Candidates that are not ready yet MUST NOT delay that post up to the full cap. A later renegotiation MAY still wait for the full gather.

#### Scenario: Accept posts before the gather cap

- **WHEN** the user answers an incoming 1:1 call and ICE gathering is not finished
- **THEN** the client posts acceptance without waiting for the full gather cap
- **AND** candidates that are already settled are included in that answer

### Requirement: A missing call on accept is cancelled

When posting acceptance reports that the call does not exist (HTTP 404), and the call has not connected yet, the client SHALL end it as cancelled. The user MUST NOT see that response as a raw signaling failure.

#### Scenario: Acceptance finds no call

- **WHEN** the user has answered and the acceptance post returns HTTP 404 because the call does not exist
- **THEN** the call ends as cancelled
- **AND** the end notice is the cancelled-call notice, not a signaling failure
