# Proposal

## Why

Clicking a calendar event opens a label-style detail dialog (When, Calendar, Organizer, Join link, footer actions). Microsoft Teams shows a peek card with time, series, location, invitee line, response counts, agenda preview, email-organizer checkbox, optional message, and Accept / Decline / Tentative. The fork should match that peek so invite handling feels familiar.

## What Changes

- Replace the calendar event dialog with a Teams-like peek card (header Join/Chat, time, location, invite/response summary, agenda, RSVP controls).
- Load richer event fields (location, body preview, series, attendee response counts) from the calendar list when present, and from Graph / Google when the peek needs them.
- RSVP may include an optional comment when «Email organizer» is on (Outlook); Google keeps sendUpdates without a message field.
- Keep Join, Chat, Copy join info, and Delete reachable from the same card.
- No **BREAKING** API change for agents or MCP.

## Capabilities

### New Capabilities

- `calendar-event-peek`: Teams-like event peek when opening a calendar item (layout, RSVP chrome, detail fields).

### Modified Capabilities

- (none)

## Impact

- UI: `crates/app/src/views/calendar_event_dialog.rs`, RSVP helpers, locales.
- Data: `CalendarEvent` in chatsvc; Outlook Graph get-event; Google parse/merge.
- App state: respond with comment; optional detail refresh on open.
