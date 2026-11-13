# Tasks

## 1. Model and persistence

- [x] 1.1 Account/calendar model (Microsoft mailbox vs Google account, calendar IDs, home calendar, write targets) and local persistence; Verify: unit tests for serialize/defaults (`cargo test -p store --lib` or new module filter)
- [x] 1.2 Extend `CalendarEvent` with source and account/calendar ID without breaking existing parser fixtures; Verify: `cargo test -p chatsvc --lib calendar`

## 2. Google auth and API client

- [x] 2.1 Google OAuth desktop (code + PKCE), store/delete tokens, document client ID source; Verify: unit tests for state/token roundtrip without network, doc section in fork README or settings hint
- [x] 2.2 Google Calendar client: calendar list, `events.list` in time window, parse → `CalendarEvent`; Verify: `cargo test` on parser fixtures (fixtures from API examples)
- [x] 2.3 Google write: `events.insert` (join link in location/description, attendees, RRULE from Repeat) and RSVP patch with sendUpdates; Verify: body-builder unit tests like `new_event_body`

## 3. Poll, merge, create routing

- [x] 3.1 Merge logic (iCal UID, normalized Teams join URL) and source labels; Verify: dedicated unit tests for dedup and no dedup on title/time only
- [x] 3.2 `calendar_loop` polls Outlook + Google in parallel; Outlook errors not fatal when Google connected; Verify: `cargo test -p app-state --lib` for loop/merge helpers where isolable, else fixture tests of merge API
- [x] 3.3 Create path: Teams join link first, then inserts per write target; Outlook-only home keeps existing Graph one-step; Verify: unit tests for target selection and error «one target failed, link still there»
- [x] 3.4 Route RSVP and reminders by source; Google snooze local; Verify: `cargo test -p app-state --lib` reminder/RSVP filters + `cargo test -p chatsvc --lib` existing Outlook reminder tests green

## 4. UI

- [x] 4.1 Settings: connect/disconnect Google, calendar list, home calendar, extra write targets; Verify: layout/state tests or manual smoke protocol in task comment after demo run
  - Settings > Calendar UI wired (connect/disconnect, home, also write). Live connect needs `TEAMS_GOOGLE_CLIENT_ID`.
- [x] 4.2 Show source on calendar blocks; new meeting uses home + write targets; Verify: UI or state tests for default targets and source display where present

## 5. Integration

- [ ] 5.1 End-to-end smoke (manual): connect Google, grid with both sources, new meeting home only, new meeting home+Google, RSVP Google, snooze Google locally; Verify: short checklist ticked, no Outlook-only regression without Google
  - Checklist:
    - [ ] Outlook-only without env: grid and new meeting as before
    - [x] Connect Google via Settings > Calendar
    - [ ] Grid shows Google + Outlook (merge without double on same iCal UID)
    - [ ] New meeting home only (Outlook)
    - [ ] New meeting home+Google dual write
    - [ ] RSVP on Google event
    - [ ] Snooze Google toast locally (no Graph error)
    - [ ] Google event with Teams link: Soon/Started toast with Join (not blocked by Outlook ReminderView)
- [x] 5.2 Extend ROADMAP calendar lines for Google accounts; Verify: entry describes fork state correctly

## 6. Calendar picker in the view (follow-up)

- [x] 6.1 Week/month load merges Outlook + Google (not Graph `calendar_view` only); Verify: `cargo test -p app-state --lib` where isolable + manual grid with Google events
- [x] 6.2 Calendar list in calendar view (Outlook + Google, on/off); toggle refreshes grid; Verify: UI smoke — list visible, toggle shows/hides source
- [x] 6.3 Update OpenSpec spec/proposal for picker + grid load; Verify: spec scenarios «Calendar picker» present
- [x] 6.4 All-day / midnight-to-midnight events only in all-day row, not full-height blocks in hour grid; Verify: `cargo test -p app-call-model --lib week_grid` (incl. `midnight_to_midnight_timed_events_sit_in_the_all_day_row`) + release installed
- [x] 6.5 Click calendar block opens event detail dialog (not chat switch / disappear); all-day chips too; chat/join only via dialog or context menu; Verify: dialog wired, unit/build green; manual after app restart
- [x] 6.6 Event detail: delete removes event from source (Outlook Graph DELETE / Google events.delete) and from grid; Verify: `cargo test -p chatsvc --lib delete_event` + release installed; manual delete on Google event after restart
- [x] 6.7 Join button with Teams link: in event detail and on calendar block (not only in join window just before start); Verify: build+install; join no longer bound to `join_available` window
- [x] 6.8 Grid refresh: agenda poll must not overwrite `calendar_week.events`; element IDs unique per day (multi-day); Verify: delete/scroll leave other events visible; `cargo check -p app-state`

## 7. Meeting start notifications (follow-up)

- [x] 7.1 Do not suppress Google events via Outlook ReminderView (`allows` only for Outlook); reminder tick from agenda **and** week grid; Verify: `cargo test -p app-state --lib google_events_stay_allowed`
- [x] 7.2 Spec/design: Soon/Started/Live toast + Join/Snooze/Dismiss/Chime for Google with Teams link; Google snooze/dismiss local; Verify: spec scenarios «Meeting start notification»

## Workflow follow-up

- After merge on the fork: `/opsx-archive` for `google-calendar` (delta to `openspec/specs/calendar-accounts/`).
- Push everyday commits and tags to `fork`, not `origin`.
