# Spec Delta

## Purpose

Signaling and SDP for camera and screen share in connected calls: escalation answers and same-peer renegotiation behave so the remote side accepts media lines and delayed camera answers still apply.

## ADDED Requirements

### Requirement: Escalation answer keeps offer line count

During media renegotiation with escalation, the answer signaled to Teams MUST have the same number of media lines as the remote offer. An internally folded multi-stream line MUST go back as exactly one signaled m-line.

#### Scenario: Multi-stream line without extra mid

- **WHEN** the remote offer carries a video line with `x-multi-stream` that was unfolded internally into several browser mids
- **THEN** the signaled answer for that role contains exactly one m-line and no extra mid used only for internal unfolding

#### Scenario: Line count matches the offer

- **WHEN** the remote offer has N media lines
- **THEN** the signaled escalation answer also has N media lines

### Requirement: Late same-peer camera answer counts

If the app sends a same-peer renegotiation for camera in a direct 1:1 and the matching answer arrives shortly after the local answer timeout, the app MUST still apply that answer when it belongs to the last sent offer. An answer with receive-side camera direction (`recvonly` from the remote party’s view) MUST count as successfully enabling local send.

#### Scenario: Answer a few seconds after timeout

- **WHEN** the local same-peer camera offer was rolled back due to timeout and the matching answer arrives shortly after
- **THEN** the app applies the answer and the camera stays or becomes sending again instead of discarding the answer
