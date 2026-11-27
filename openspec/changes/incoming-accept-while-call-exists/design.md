## Context

`ring_task` in `crates/calling/src/engine.rs` attaches and sends ringing as soon as the invite arrives. After the user answers, `drive` in `crates/calling/src/call/mod.rs` builds the SDP answer and, for a 1:1, waits in `Gathered::candidates` until gathering is settled or `GATHERING_LIMIT` (5 s) elapses. Only then does it `POST acceptance`. Settled already means "gathering complete, or 200 ms after a UDP relay" (`RELAY_SETTLE`). A 404 body `The requested call does not exist` is turned into `Error::Signaling` and then `EndReason::Failed`, whose notice is `Call failed: …`.

## Decisions

1. Add a bounded gather read used only by the incoming 1:1 answer. It returns as soon as gathering is settled, and otherwise after `RELAY_SETTLE`, with whatever candidates exist. It does not mark gathering complete, so a later offer can still wait the full cap.
2. Recognize a missing call only when the signaling error is from `POST acceptance`, the status is HTTP 404, and the body says the call does not exist. While the call state is still connecting, that error ends the call as `EndReason::Cancelled` (`Call cancelled`). Any other accept error stays a failure.

## Out of scope

- Changing the 5 s cap for outgoing offers or later renegotiation
- Retrying acceptance against a new URL
