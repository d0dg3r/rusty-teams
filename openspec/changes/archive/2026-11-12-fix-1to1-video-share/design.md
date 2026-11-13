# Design

## Context

See `proposal.md`. Call report `20261112T130854Z-1to1`: escalation answer 14 lines on offer with 13 (extra `mid 3-0`), same-peer camera answer ~5 s after 40s timeout, camera open with `CameraFormat: Failed to Fufill`.

`from_teams_offer` unfolds `a=x-multi-stream` on mid 3 into browser mids `3-0` and `3`. `to_teams_answer` calls `to_teams_offer` with the remote `OfferPlan` and writes both mids as separate m-lines.

## Goals / Non-Goals

**Goals:**

- Signaled answers: one m-line per Teams offer line, fold back to `x-multi-stream`.
- Same-peer: short grace after timeout for matching camera answers.
- Camera open: property error → fallback chain.

**Non-Goals:**

- Command queue, portal lifetime, PipeWire BGRA (only after retest).
- Share grace without answer (server `408`).

## Decisions

### Fold only in the signaled answer

Browser mids stay unique internally (`3-0`, `3`). When writing the Teams answer: gallery carrier as with offers — omit non-carrier mids, carrier with `x-multi-stream` count. `to_teams_answer` can use the same `to_teams_offer` path once the plan drives folding correctly; regression test offer with 13 lines → answer 13 lines, no `a=mid:3-0`.

### Late answer: short grace, do not extend timeout

After `SAME_PEER_ANSWER_LIMIT` rollback + `undo_change` as today. Additionally keep last same-peer offer identity (reply_tags / signaled / change) for a few seconds. When a matching answer arrives: `apply_answer`, camera on again, `recvonly` on remote side counts as send success. No general raise to 60+ s (share had no answer).

### Camera: list optional

`open_picked_format` may on `compatible_camera_formats` failure go straight into the existing `open_camera` fallback chain (closest NV12/YUYV, AbsoluteHighest) instead of propagating the error.

## Risks / Trade-offs

- [Late answer after undo starts capture twice] → `start_camera` idempotent or only apply UI/SDP when capture already runs; else restart capture.
- [Wrong answer in grace] → only `answers_offer` with stored reply_tags.
- [Fold changes conference offers] → test with multi-stream offer and existing fold test for browser mids.

## Migration Plan

No data migration. Deploy: fork build / local install. Rollback: previous tag.
