# Tasks

## 1. Scroll target and follow state

- [x] 1.1 Replace fixed 08:00 scroll with offset from local time (+ viewport bias, clamp); Verify: unit test for offset helper (hour/minute → pixels) in `crates/app` or extracted module — `cargo test -p app --lib` filtered to helper name
- [x] 1.2 Introduce `follow_now`: on when opening day/week and Today, off after detected manual scroll; programmatic `set_offset` must not end follow; Verify: unit tests for state transitions (on → manual off → Today on again)

## 2. Now line and timer

- [x] 2.1 Periodic tick in `CalendarView` while day/week visible: redraw now line; when `follow_now` pull viewport; stop timer on month/hidden; Verify: manual smoke (line moves without calendar poll) + existing calendar layout guards green where present

## 3. Integration

- [x] 3.1 Today and opening calendar island trigger align-to-now; month unchanged; Verify: short smoke (open, scroll, Today, month) and `cargo test -p app --lib` for new helper/state tests

## Workflow follow-up

- After merge on the fork: `/opsx-archive` for `calendar-scroll-now`.
- Implement and release independently of `google-calendar`.
