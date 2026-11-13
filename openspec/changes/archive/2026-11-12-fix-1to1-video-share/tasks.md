# Tasks

## 1. Escalation answer without extra m-line

- [x] 1.1 `to_teams_answer` / offer plan: write gallery fold (`3-0` + `3`) as one signaled m-line with `x-multi-stream`; Verify: unit test offer 13 lines → answer 13 lines, no `a=mid:3-0`
- [x] 1.2 Keep existing fold test for browser mids green; Verify: `cargo test -p calling --lib sdp`

## 2. Same-peer late answer

- [x] 2.1 After same-peer timeout keep short grace with reply_tags/change and still apply matching answer (`recvonly` = send ok); Verify: unit or drive-near test / documented timeline check
- [x] 2.2 Verify: `cargo test -p calling --lib` filter renegotiation/call where present

## 3. Camera open fallback

- [x] 3.1 `open_picked_format` / `open_camera`: format property error → fallback chain instead of fatal; Verify: `cargo test -p calling --lib camera`

## 4. Integration

- [x] 4.1 `cargo test -p calling --lib` green (441 passed; `sdp_golden` 5/5; ignored camera hardware open ok)
- [x] 4.2 Automated camera-open smoke green; full Hyprland 1:1 call report remains operator retest after install — queue/PipeWire only if report still red
