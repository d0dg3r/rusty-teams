## Why

Answering a 1:1 call posts acceptance only after ICE gathering finishes or hits a 5 second cap. The service can drop the call in that wait. The client then shows a raw signaling failure (`POST acceptance` HTTP 404, "The requested call does not exist.") even though the caller is simply gone.

## What Changes

- The incoming 1:1 answer uses candidates that are already settled (including a UDP relay plus the existing short settle). It does not wait out the full gather cap before `POST acceptance`. Later renegotiation still uses the full gather.
- When `POST acceptance` answers HTTP 404 because the call does not exist, the call ends as cancelled while it is still connecting, instead of as a failed signaling error.

## Capabilities

### New Capabilities

### Modified Capabilities

- `call-media-negotiation`: answering an incoming 1:1 call does not block on the full ICE gather cap, and a call that is already gone ends as cancelled.

## Impact

- Incoming answer setup in `crates/calling`. No change to in-call renegotiation budgets. No UI chrome.
