# Proposal

## Why

Without an Exchange mailbox the calendar stays empty or fails to load; users who also rely on Google do not see those events in the app. The calendar view and «New meeting» today depend entirely on Teams/Outlook. Google as a second account (and more calendars later) makes the calendar usable without a Microsoft 365 mailbox and lets both worlds live in the same grid.

## What Changes

- The user can connect and disconnect a Google account for calendar (OAuth, refresh token stored locally).
- The week/month grid shows events from Teams/Outlook and connected Google calendars; duplicate meetings merge (iCal UID or same Teams join link) while sources stay identifiable.
- The user picks a home calendar (Outlook or a Google calendar) and optional extra write targets; «New meeting» writes there and attaches the Teams join link to the event.
- Accept/tentative/decline and reminder snooze/dismiss route to the event source; Google snooze/dismiss stay local in the app (Google has no Outlook ReminderView).
- **Meeting start notifications** (Soon/Started/Live toasts with Join, Snooze, Dismiss, Chime) also apply to Google events with a Teams join link — same UX as Outlook.
- Prepared for more calendar accounts later: home calendar and write targets are not bound to «Google only».
- No **BREAKING** change for existing Outlook-only users: without a Google connection behaviour stays as today.

## Capabilities

### New Capabilities

- `calendar-accounts`: Multiple calendar accounts (Teams/Outlook plus Google and more later), connected sources in the grid, home calendar and selectable write targets for new meetings, source-specific RSVP and reminders.

### Modified Capabilities

- (none)

## Impact

- UI: Settings for Google connection, home calendar, and write targets; **calendar view with calendar list** (Outlook + Google, on/off like Teams); calendar blocks with source; **all-day row** for all-day and midnight-to-midnight events; **event detail dialog** on click (instead of switching to chat) including **Delete** and **Join** when a Teams link exists; Join on the calendar block too; «New meeting» dialog writes to chosen targets. Week/month grid loads and shows all selected sources (not Outlook only).
- Backend: Polling multiple sources, merge, create/RSVP/reminder routing; Google Calendar API + OAuth beside MSAL/Graph.
- Secrets: Google OAuth client ID/secret or desktop app flow; tokens stored locally beside the Microsoft cache.
- Fork release: Feature on `fork` (`d0dg3r/rusty-teams`); no need for one giant Upstream PR with the whole stack.
