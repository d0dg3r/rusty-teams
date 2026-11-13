# Design

## Context

See `proposal.md` — Why. In `crates/app/src/views/calendar_view.rs`, `Render` once sets `scrolled_to_morning` and scrolls to `FIRST_VISIBLE_HOUR` (8). The now line (`now_minute`) draws only on re-render; `CalendarView` observes `AppState` but has no own clock tick. «Today» (`calendar_to_today`) only sets the date.

## Goals / Non-Goals

**Goals:**

- Scroll target = current local time (small offset so the line does not stick to the top edge).
- Periodic re-render / scroll follow for now line and follow mode.
- Follow off as soon as the user scrolls the hour grid manually; reset on Today / open day/week.

**Non-Goals:**

- Scroll month grid.
- Scroll to a specific event (time only).
- Time zone switcher UI.
- Google calendar (separate change).

## Decisions

### 1. Scroll offset from local time

- **Choice:** `offset_y = -(hour + minute/60) * HOUR_HEIGHT + viewport_bias`, bias about one third of visible grid height (line not at top). Clamp to day bounds (0–24h).
- **Why:** Replaces the constant 8 AM; same `ScrollHandle` API.
- **Alternative:** Always pin now to top — feels cramped.

### 2. Follow flag instead of «scroll once»

- **Choice:** State `follow_now: bool` (default true on open day/week and on Today). Manual scroll → `follow_now = false`. Today / showing grid again → `true` and scroll immediately.
- **Why:** Stays aligned without chasing the user when they read the afternoon.
- **Alternative:** Always follow — rejected.

### 3. Clock tick

- **Choice:** Light timer in `CalendarView` (e.g. every minute, or ~15–30s) while day/week visible: `cx.notify()`; when `follow_now`, reset scroll offset.
- **Why:** Now line and follow need a tick independent of calendar poll.
- **Alternative:** Only on AppState events — line stands still.

### 4. Detect manual scroll

- **Choice:** Watch scroll offset on the handle (or scroll events on the grid surface): offset differs from expected follow target and did not come from our set → follow off.
- **Why:** No extra «Live» button.
- **Risk:** Our own `set_offset` must not turn follow off — short «programmatic» guard.

## Risks / Trade-offs

- [False positive «manual scroll»] → Guard around programmatic set; only deviation from target counts.
- [Timer runs in background] → Start timer only when calendar island day/week visible; stop on month/other tab.
- [Very short viewport height] → Smaller bias / clamp; keep now visible.

## Migration Plan

- Client-only UX; no persistence schema.
- Rollback: restore old one-time scroll to 8 AM.

## Open Questions

- No spec-changing open items; exact timer period (30s vs 60s) is implementation detail.
