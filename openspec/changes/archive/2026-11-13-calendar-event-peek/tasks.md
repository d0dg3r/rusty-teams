# Tasks

## 1. Event fields and parsers

- [x] 1.1 Extend `CalendarEvent` with location, body preview, series flag, series master id, and response counts; parse from Teams MT calendarView when present; Verify: `cargo test -p chatsvc --lib calendar`
- [x] 1.2 Parse Google location, description, attendee counts, recurrence; merge keeps richer fields; Verify: Google parse/merge tests

## 2. Detail fetch and RSVP comment

- [x] 2.1 Outlook Graph GET event for missing peek fields on open; iCal UID fallback on 404; Verify: unit test for request URL/select and merge into event
- [x] 2.2 Pass RSVP comment through `send_reply` / `respond_to_event` when Email organizer is on; Verify: schedule respond body test

## 3. Peek UI and locales

- [x] 3.1 Rebuild `calendar_event_dialog` as Teams peek (Join/Chat, time, location, invite, counts, agenda, Email organizer, message, Accept/Decline/Tentative, more→Delete); Verify: compile + locale keys resolve EN/DE
- [x] 3.2 Wire open → optional detail refresh into peek state; series Accept/Decline menus when master id known; Verify: `cargo test -p chatsvc --lib` and app locale calendar tests

## 4. Full agenda and expanded view

- [x] 4.1 `CalendarEvent` gains `body_html` and `attendees` (name, address, response, required); parse Graph and MT detail shapes; merge / week reload keep them; detail fetch when either is missing; Verify: `cargo test -p chatsvc --lib calendar`
- [x] 4.2 Peek agenda renders `body_html` via the message HTML pipeline (fallback preview), scrollable with fixed footer; Verify: compile + live check on a long agenda
- [x] 4.3 Enlarge opens expanded view: toolbar, details + agenda left, Tracking panel grouped by response right; Verify: release build, install, screenshot compact + expanded

## 5. Google event fields

- [x] 5.1 `CalendarEvent` gains reminders, source_link, web_link, calendar_name; Google parse normalises description to HTML, reads reminders (overrides or list defaultReminders), source, htmlLink; merge / week reload keep them; fetch sets calendar_name from the selected calendar summary; Verify: `cargo test -p chatsvc --lib calendar`
- [x] 5.2 Peek shows calendar / reminders / source rows for Google; multi-day when label; Google actions Open in Google Calendar and Email guests; locale keys EN/DE; Verify: compile + locale keys resolve
- [x] 5.3 Release install with Google client id; open a Google event (KubeCon-style) and screenshot compact + expanded; Verify: `scripts/install-linux-local.sh --restart` + grim

## Workflow follow-up

- After merge on the fork: `/opsx-archive` for `calendar-event-peek`.
