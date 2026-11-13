# Design

## Context

See `proposal.md`. Today `open_calendar_event` builds a Dialog with labeled rows and a footer (Delete, Close, RSVP dropdown, Chat, Join). List data from Teams MT `calendarView` and Google events lacks location, body preview, series flags, and attendee counts. Graph `accept` / `decline` already accept a `comment` field but the client always sends `""`.

## Goals / Non-Goals

**Goals:**

- Peek layout matching Teams invite chrome for invitees and a simpler organizer view.
- Enrich `CalendarEvent` and fill missing fields when the peek opens.
- Pass RSVP comment when emailing the organizer (Outlook).

**Non-Goals:**

- Propose new time UI (chevron may exist later).
- Attachment list.
- Changing the week/month grid block chrome beyond existing Join chips.
- Dial-in numbers beyond existing Copy join info text.

## Decisions

### 1. Peek opens immediately, then fills details

- **Choice:** Open with whatever the week poll already has; if location / body / counts are empty for Outlook, `GET /me/events/{id}` with selected fields and patch the open card.
- **Why:** List payloads are often thin; Graph already used for RSVP/delete.
- **Alternative:** Block open until Graph returns — slower and fails offline.

### 2. Series actions gated on master id

- **Choice:** Show «Series» when type/recurrence indicates a series. Accept/Decline chevron offers «This occurrence»; «Entire series» only when `series_master_id` is known and the same reply endpoint accepts that id.
- **Why:** Avoid calling reply with an unknown master id.
- **Alternative:** Always show both — rejected without a verified master id path.

### 3. Google RSVP message omitted

- **Choice:** No message field for Google events; checkbox still maps to `sendUpdates`.
- **Why:** Google Calendar patch has no organizer comment equivalent on the same path.
- **Alternative:** Put message in a calendar note — not Teams-like and out of scope.

### 4. Enlarge opens the expanded event view

- **Choice:** The header enlarge control switches the same peek entity into an expanded dialog (wide card, toolbar, details + agenda left, Tracking panel right). Join URL and Copy join info live in the Join menu.
- **Why:** Matches the Teams «Event instance» window, which is what users expect from enlarge.

### 5. Full body and attendees from the detail fetch

- **Choice:** `CalendarEvent` carries `body_html` and `attendees`. `bodyPreview` from list payloads is server-truncated (about 255 chars), so the peek fetches details when `body_html` or `attendees` is missing: Graph `GET /me/events/{id}` with `body` and `attendees`; when Graph has no body, Teams MT `beta/me/calendarEvents/{id}` (`bodyContent`, `attendees`).
- **Why:** Only the detail payloads hold the full agenda and roster.

### 6. Reuse the message HTML pipeline

- **Choice:** Render `body_html` with `html_to_spans` → `layout_blocks` → `render_blocks` (same as chat messages); fall back to `body_preview` as plain text.
- **Why:** Bold, lists, links and link opening already work there; no second HTML renderer.

### 7. Google description normalised to HTML at parse time

- **Choice:** Plain Google `description` text is escaped, `http(s)://` runs become `<a href>`, and line breaks become `<br>` before storing as `body_html`. Reminder minutes come from `reminders.overrides` when present, otherwise from the list response's `defaultReminders` when `useDefault` is set. `source` / `htmlLink` / calendar summary fill `source_link`, `web_link`, and `calendar_name`.
- **Why:** The peek already renders HTML; Google list payloads are plain text without those fields on the UI otherwise.
- **Alternative:** A second plain-text renderer in the peek — rejected to keep one pipeline.

## Risks / Trade-offs

- [Graph id ≠ MT objectId] → Same fallback as respond/delete (iCal UID lookup) if GET 404.
- [Attendee list huge] → Tracking panel scrolls; groups are collapsible.
- [Inline images in body (`cid:`)] → Image placeholders are stripped.
- [Google default reminders missing from a thin list payload] → Reminder row omitted until defaults are present.

## Migration Plan

- Client-only; no store schema.
- Rollback: restore prior labeled dialog.

## Open Questions

- None that block the first ship; series «entire series» depends on master id availability from Graph.
