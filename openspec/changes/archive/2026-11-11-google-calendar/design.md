# Design

## Context

See `proposal.md` — Why. Today: poll in `crates/app-state/src/backend.rs` (`calendar_loop`) loads only `chatsvc::Calendar` (Teams MT `calendarView`). Create and RSVP go through Graph `POST /me/events` and accept/decline in `crates/chatsvc/src/calendar/schedule.rs`. Reminders via Graph `reminderView` / snooze / dismiss in `reminders.rs`. Meet now without mailbox: Teams Scheduling API in `calendar.rs` (`create_meet_now`). UI: `crates/app/src/views/calendar_view.rs`, new-meeting dialog, settings sections under `crates/app-state` / `crates/app`.

## Goals / Non-Goals

**Goals:**

- Provider interface across Outlook and Google, merge in poll, home calendar + optional write targets.
- Google OAuth desktop, tokens local, polling instead of push webhook.
- Create: Teams join link first (Graph `onlineMeetings` or existing Scheduling API), then insert per write target.
- RSVP and reminders route by event source; Google snooze local.

**Non-Goals:**

- Gmail, Google Drive, Google Meet as conference provider.
- Public webhook / Google push sync channel.
- Full sync engine (offline queue across app restarts for Google writes — best-effort + show errors is enough).
- Upstream PR to `danieldaeschle/rusty-teams` in this change.

## Decisions

### 1. Capability model: accounts + calendars, not a «Google-only» API in the UI

- **Choice:** Persistence and settings speak in terms of account (Microsoft mailbox vs Google account) and calendar IDs (primary / secondary). Home calendar and write targets are IDs in this model.
- **Why:** More providers later without dialog rework.
- **Alternative:** Only «Google on/off» — rejected because of «more calendars later».

### 2. OAuth: Google desktop / loopback, calendar scope

- **Choice:** Authorization code + PKCE (or installed desktop app), scopes at least calendar read/write (`calendar.events` / `calendar` as needed). Refresh token under app data directory, separate from MSAL cache.
- **Why:** Fits desktop without a browser plugin; Linux sign-in stays Chrome for Microsoft.
- **Alternative:** ICS subscribe read-only only — does not cover writes.

### 3. Read path: poll in parallel, then merge

- **Choice:** `calendar_loop` **and** week/month load (`load_calendar_week`) fetch Outlook (when selected; errors not fatal if Google is connected) and Google `events.list` for selected calendars in the same time window; merge on `ical_uid` or normalized Teams join URL; extend `CalendarEvent` with `source` / account and calendar ID. Poll results also feed the visible grid (not agenda only).
- **Why:** UI stays one grid; dedup avoids double blocks when «both write». Graph-only week view was a gap — Google stayed invisible.
- **Alternative:** Two separate grids — worse UX.

### 4. Create path: meeting link first, then calendar inserts

```
New meeting
  -> resolve write targets (home + optional extras)
  -> create Teams online meeting (Graph onlineMeetings or Scheduling API)
  -> for each target:
       Outlook home/extra -> Graph POST /me/events with isOnlineMeeting
                            OR patch body with join URL if meeting already created
       Google target      -> events.insert with location/description = join URL,
                            attendees, RRULE from dialog Repeat
  -> surface join URL even if a secondary insert fails
```

- **Why:** Google cannot issue `teamsForBusiness`; without a mailbox today’s one-step Graph POST fails.
- **Alternative:** Graph `isOnlineMeeting` only and Google as copy after — breaks without mailbox.

When home calendar is Outlook and there are no extra targets: today’s one-step path may remain (fewer round trips).

### 5. RSVP / reminders

- **RSVP:** Decide by `source` — Outlook: `Calendar::respond`; Google: `events.patch` `attendees[].responseStatus` + `sendUpdates`.
- **Reminders / start notifications:** Same toast model for Outlook and Google (Soon ≈ 5 min before, Started, Live; Join / Snooze / Dismiss / Chime). Outlook still via Graph `reminderView` (snooze/dismiss write there). Google: local phases from event start/`join_url`; Outlook `allows` gate applies **only** to Outlook events (otherwise Google toasts were suppressed once ReminderView loaded). Reminder tick reads agenda **and** week grid (dedup). Google snooze/dismiss stay local.

### 6. Settings UI and calendar list in the view

- Section «Calendar» / calendar accounts: connect Google, disconnect, calendar list (primary pre-selected), home calendar dropdown, checkboxes «also write to …».
- **Calendar view:** left «CALENDARS» list with Outlook + each Google calendar (on/off), like Teams — without opening Settings.
- New-meeting dialog: write targets from settings as default, optional override only when needed (default: settings suffice).

### 6b. All-day display and event detail

- Google often delivers holidays/week markers as `dateTime` 00:00→00:00 (local midnight) instead of `date`. The grid treats these like `all_day`: all-day row only, no full-height block in the hour grid (`is_effective_all_day` with local offset; multi-day 00:00→23:59 too).
- Click on a block (timed or all-day) opens an **event detail dialog** (time, source, organizer, Join/RSVP/Chat/**Delete**). No automatic switch to meeting chat — that made Google events «disappear» or never show details. Chat remains context menu / dialog button.
- **Join:** As soon as a Teams join link is on the event (`online` + URL), **Join** appears in the detail dialog and on the timed calendar block — regardless of join time window (window still applies to reminders/toasts).
- **Delete:** Optimistic remove from grid; Outlook `DELETE /me/events/{id}` (iCal UID fallback like RSVP); Google `events.delete` with `sendUpdates` like RSVP. On failure restore + notice.
- **Grid SoT:** `load_calendar_week` fills `calendar_week.events`. Agenda poll (`apply_calendar`) writes only `calendar_events` and must not overwrite week/month grid with the shorter agenda window (otherwise e.g. Mon/Tue vanish after delete/poll). GPUI element IDs are day-qualified (`object_id` + date) so multi-day all-day chips do not collide on scroll.

### 7. Delivery

- Development and release on remote `fork` (`d0dg3r/rusty-teams`). No giant Upstream PR.

## Risks / Trade-offs

- [Google OAuth client registration / verification] → Desktop client in the fork’s Google Cloud project; do not commit secrets, document config via env/build flag.
- [Duplicate events despite merge] → Unit-test merge keys (iCal UID, join URL); do not auto-merge on title/time only.
- [Create: meeting exists, insert failed] → Still show join link; error text which target failed; poll does not clean orphan meetings (onlineMeeting remains).
- [Local token theft] → Same protection class as MSAL cache; no cloud sync.
- [Google rate limits] → Same window as today’s poll; backoff on 429.

## Migration Plan

- Feature behind connected Google account: without connection unchanged Outlook-only.
- Existing users: home calendar default = Outlook when mailbox ok, else first Google calendar after connect.
- Rollback: disconnect Google + feature flag/build without Google client ID → old path.

## Open Questions

- Exact Google OAuth client provisioning for the fork build (which client ID source at compile time) — does not change specs, only packaging.
- Whether secondary Google calendars (not primary) are connectable in the first slice or only primary + list later — spec allows list; implementation can ship primary first and add calendars in the same settings UI.
