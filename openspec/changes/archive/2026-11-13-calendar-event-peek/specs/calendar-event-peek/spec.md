# Spec Delta

## Purpose

Shows a Teams-like peek when the user opens a calendar event: time, series, location, invite summary, agenda preview, and RSVP controls while keeping Join, Chat, Copy join info, and Delete available.

## ADDED Requirements

### Requirement: Invitee peek layout

When an invited user opens a calendar event that is not cancelled, the app SHALL show a peek with title, Join and Chat when available, a time row, a location row, an invitee line naming the organizer, response counts when known, an agenda preview when known, an Email organizer control, and Accept, Decline, and Tentative actions. The peek MUST NOT show a labeled Calendar source row.

#### Scenario: Online Teams meeting invite

- **WHEN** the user opens an online meeting they were invited to
- **THEN** the peek shows Join when a join link exists
- **AND** shows Chat when a meeting thread id exists
- **AND** shows time and a location (from the event or a Teams-meeting fallback)
- **AND** shows that the organizer invited the user
- **AND** offers Accept, Decline, and Tentative

#### Scenario: Response counts

- **WHEN** attendee response counts are known
- **THEN** the peek shows Accepted, Declined, and Didn't respond counts
- **AND** shows Tentative only when that count is greater than zero

#### Scenario: Optional RSVP message

- **WHEN** Email organizer is on for an Outlook-sourced invite
- **THEN** the user may add an optional message that is sent with the RSVP
- **WHEN** Email organizer is off
- **THEN** the RSVP is sent without notifying via that message path as configured by the send flag

### Requirement: Organizer peek

When the user is the organizer, the peek SHALL show the organizer name without an «invited you» line and MUST NOT show invitee RSVP Accept / Decline / Tentative controls.

#### Scenario: Own meeting

- **WHEN** the user opens an event where they are the organizer
- **THEN** the peek does not show Accept, Decline, or Tentative
- **AND** still offers Join, Chat, and Delete when those actions apply

### Requirement: Series marker

When the event is part of a recurring series, the peek SHALL mark the time row as a series.

#### Scenario: Series occurrence

- **WHEN** the opened event is a series occurrence or master
- **THEN** the peek shows a Series indicator next to the time

### Requirement: Join details without default raw URL

The peek SHALL keep the join URL and Copy join info in the Join menu so the compact peek matches Teams chrome without showing the raw URL by default.

#### Scenario: Copy join info from Join menu

- **WHEN** the user opens the Join menu
- **THEN** Copy join info is available

### Requirement: Full agenda in peek

The peek SHALL show the full event body (not only the server-truncated preview) with its formatting (paragraphs, bold, lists, links) in a scrollable agenda area, while header and RSVP footer stay visible. When only a plain preview is known, the peek SHALL show that preview until the full body arrives.

#### Scenario: Long agenda

- **WHEN** the event body is longer than the visible agenda area
- **THEN** the agenda scrolls inside the peek
- **AND** the RSVP footer stays visible

#### Scenario: Full body after detail fetch

- **WHEN** the list data only carries a truncated preview
- **THEN** the peek fetches the full body on open and replaces the preview with the formatted body

### Requirement: Expanded event view with tracking panel

The peek's enlarge control SHALL open an expanded event view: an action toolbar (Accept, Decline, Tentative, more with Delete, Join, Chat), the event details and the full formatted agenda on the left, and a Tracking panel on the right with the organizer and attendees grouped by response (Accepted, Tentative, Declined, Didn't respond) with counts and Required / Optional labels. The same control SHALL return to the compact peek.

#### Scenario: Enlarge an invite

- **WHEN** the user enlarges the peek of an event with known attendees
- **THEN** the expanded view shows the full agenda on the left
- **AND** the Tracking panel lists attendees grouped by response with counts

#### Scenario: Attendees unknown

- **WHEN** the attendee list is not known
- **THEN** the Tracking panel shows the organizer and the response counts only

### Requirement: Delete remains available

The peek SHALL keep Delete reachable (for example under a more menu) for events the user can remove.

#### Scenario: Delete from peek

- **WHEN** the user chooses Delete from the peek
- **THEN** the event is removed using the existing calendar delete path

### Requirement: Google event fields in peek

When the opened event is from Google Calendar, the peek SHALL show Google-specific fields: the calendar name, a description that keeps line breaks and clickable links, reminder offsets when known, and a source link when the event carries one. Google actions SHALL include Open in Google Calendar when a web link exists and Email guests when attendee addresses exist; Delete stays under the more menu. Outlook peeks MUST NOT gain these Google-only rows or actions.

#### Scenario: Plain-text description

- **WHEN** a Google event has a plain-text description with line breaks and an `http(s)` URL
- **THEN** the peek shows the description with preserved line breaks
- **AND** the URL is clickable

#### Scenario: Reminders listed

- **WHEN** the Google event has reminder offsets (overrides or calendar defaults)
- **THEN** the peek lists each reminder (when the event starts, or N minutes / hours / days before)

#### Scenario: Source link

- **WHEN** the Google event has a `source` title and URL
- **THEN** the peek shows the title and a View source control that opens that URL

#### Scenario: Calendar name

- **WHEN** the Google event belongs to a named calendar the user selected
- **THEN** the peek shows that calendar name

#### Scenario: Google actions

- **WHEN** the user opens their own Google event with a web link and guests
- **THEN** the peek offers Open in Google Calendar and Email guests
- **AND** Delete remains under the more menu
