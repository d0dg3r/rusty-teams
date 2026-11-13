# calendar-accounts Specification

## Purpose

Multiple calendar accounts (Teams/Outlook and Google, more later) in the same grid, with a home calendar, selectable write targets, and source-specific RSVP and reminders.

## Requirements

### Requirement: Connect Google calendar account

The app SHALL let the user connect a Google account for calendar access and store the credentials on the device until the user disconnects. Disconnecting MUST stop reading and writing that account's calendars.

#### Scenario: Connect Google

- **WHEN** the user chooses to connect Google for calendar
- **THEN** the app completes Google sign-in for calendar scopes
- **AND** the connected account appears among calendar accounts

#### Scenario: Disconnect Google

- **WHEN** the user disconnects a connected Google calendar account
- **THEN** its events leave the calendar grid on the next refresh
- **AND** it is no longer offered as home calendar or write target

### Requirement: Project Desktop client for Connect Google

Official release builds SHALL include the project Google OAuth Desktop client so the user can connect Google Calendar without exporting client credentials in a shell. Runtime environment variables MUST still override the baked client for developers. Connect MUST open the authorize URL in the user's preferred external browser (or the system default when none is set). User tokens MUST stay on the device until disconnect.

#### Scenario: Connect from a Dock or Start Menu install

- **WHEN** the user runs an official release build and chooses Connect Google
- **THEN** Google sign-in for calendar scopes completes without requiring `TEAMS_GOOGLE_CLIENT_*` in the process environment
- **AND** the connected account appears among calendar accounts

#### Scenario: Developer override without rebuild

- **WHEN** a developer sets `TEAMS_GOOGLE_CLIENT_ID` (and optionally `TEAMS_GOOGLE_CLIENT_SECRET`) in the environment before starting a local build
- **THEN** that client is used instead of any baked-in values
- **AND** Connect still stores tokens only on the device

#### Scenario: Reconnect after disconnect

- **WHEN** the user disconnects Google and later chooses Connect Google again on the same release build
- **THEN** the same one-click flow runs again
- **AND** no client-id field is required in Settings

### Requirement: Calendar picker in the calendar view

The calendar view SHALL offer a calendar list (Outlook mailbox and each connected Google calendar) so the user can show or hide each calendar in the grid without opening Settings. Toggling a calendar MUST refresh the visible week or month grid accordingly.

#### Scenario: Toggle Google calendar in the picker

- **WHEN** the user turns a connected Google calendar on in the calendar list
- **THEN** its events appear in the week or month grid after refresh
- **AND** turning it off removes those events from the grid on the next refresh

#### Scenario: Toggle Outlook in the picker

- **WHEN** the user turns Outlook off in the calendar list while Google calendars remain on
- **THEN** the grid keeps showing the selected Google events
- **AND** Outlook events are not shown until Outlook is turned on again

### Requirement: Merged calendar grid from connected accounts

The app SHALL show events from the Teams/Outlook calendar (when available and selected) and from each selected Google calendar in the same week and month views. The week and month grid load MUST include those sources (not only the Outlook Graph path). Events that represent the same meeting MUST appear once, using matching iCal UID or the same Teams join URL when present. Each visible block MUST indicate its calendar source.

#### Scenario: Both sources visible

- **WHEN** Outlook and at least one Google calendar are available
- **THEN** events from both appear in the same calendar grid
- **AND** each block shows whether it comes from Outlook or Google

#### Scenario: Duplicate meeting collapsed

- **WHEN** the same meeting exists in Outlook and Google with the same iCal UID or the same Teams join URL
- **THEN** the grid shows one block for that meeting
- **AND** the block still indicates the sources that contributed

#### Scenario: Google only without mailbox

- **WHEN** the Teams/Outlook calendar fails or is empty and a Google calendar is connected
- **THEN** the grid still shows the Google events
- **AND** the app does not leave the calendar unusable solely because Outlook failed

### Requirement: Home calendar and write targets

The user SHALL choose one home calendar among available calendars (Outlook mailbox or a connected Google calendar). «New meeting» MUST always write to the home calendar. The user MAY select additional write targets so the same meeting is also created there. The set of targets MUST be extensible when more calendar accounts are added later.

#### Scenario: Write to home only

- **WHEN** the user creates a new meeting with only the home calendar selected
- **THEN** the meeting is created in that home calendar
- **AND** it is not created in other calendars

#### Scenario: Write to home and another calendar

- **WHEN** the user creates a new meeting with the home calendar and an additional write target selected
- **THEN** the meeting is created in each selected calendar
- **AND** each created event carries the Teams join link when the meeting is online

#### Scenario: Home is Google without mailbox

- **WHEN** the home calendar is a Google calendar and Outlook create is unavailable
- **THEN** «New meeting» still creates the Teams join link
- **AND** stores the meeting in the selected Google calendar with that join link

### Requirement: RSVP follows event source

Accept, tentatively accept, and decline MUST target the calendar that owns the selected event. Outlook events use the existing mailbox response path. Google events update the user's response on that Google event and honour the user's choice to send or not send a response to organizers.

#### Scenario: Decline a Google invitation

- **WHEN** the user declines a Google-sourced invitation with «Send a response» on
- **THEN** the Google event response becomes declined
- **AND** organizers are notified according to Google's send-updates behaviour

#### Scenario: Accept an Outlook invitation

- **WHEN** the user accepts an Outlook-sourced invitation
- **THEN** the response is written through the Outlook path as today

### Requirement: Meeting start notifications for calendar sources

Online meetings with a Teams join URL from Outlook or Google SHALL raise the usual meeting reminder toast: about five minutes before start (Soon), when the meeting has started (Started), and Live when the meeting chat is already running. The toast MUST offer Join, and for Soon also Snooze; Dismiss and a start chime MUST work as for Outlook meetings. Google meetings MUST NOT be suppressed merely because the Outlook reminder view is loaded.

#### Scenario: Google meeting soon toast

- **WHEN** a Google-sourced online meeting with a Teams join URL starts within the lead window
- **THEN** a meeting toast appears with Join and Snooze
- **AND** a start chime may fire when the meeting reaches Started or Live

#### Scenario: Google toast after Outlook reminder poll

- **WHEN** Outlook ReminderView has already been loaded for nearby meetings
- **THEN** an eligible Google meeting in the same window still shows its toast
- **AND** Outlook meetings continue to honour ReminderView fire times

### Requirement: Reminder actions by source

Snooze and dismiss for Outlook-sourced reminders MUST continue to write to Outlook. For Google-sourced reminders, dismiss MAY clear the toast without requiring an Outlook write; snooze MUST stay in the app because Google does not offer Outlook-style absolute snooze.

#### Scenario: Snooze Outlook reminder

- **WHEN** the user snoozes an Outlook meeting reminder
- **THEN** the snooze is stored on the Outlook reminder as today

#### Scenario: Snooze Google reminder locally

- **WHEN** the user snoozes a Google-sourced meeting reminder
- **THEN** the toast is cleared locally for the Soon phase without writing to Outlook ReminderView
- **AND** the toast may return when the meeting reaches Started if still eligible

### Requirement: Polling without Google push webhook

Calendar updates from Google SHALL be discovered by polling on an interval comparable to the existing calendar refresh. The app MUST NOT require a public webhook endpoint for Google push notifications.

#### Scenario: External Google change appears after poll

- **WHEN** an event is added or changed in Google outside the app
- **THEN** the next successful calendar poll updates the grid accordingly

### Requirement: All-day events stay in the all-day row

Events marked all-day, and timed events that only span local midnights (start and end at 00:00 local with end after start), MUST appear in the all-day header row of the day or week grid. They MUST NOT render as full-height blocks in the timed hour grid.

#### Scenario: Midnight-to-midnight Google marker

- **WHEN** a Google event spans from local midnight to the next local midnight without the all-day flag
- **THEN** the week or day grid places it in the all-day row
- **AND** the timed hour columns stay free of that event's fill

#### Scenario: True all-day holiday

- **WHEN** a Google or Outlook event is marked all-day
- **THEN** it appears only in the all-day row for each overlapping day

### Requirement: Calendar event detail on click

Clicking a calendar event block (timed or all-day) SHALL open an event detail dialog that shows the event's time, calendar source, and available actions (join, RSVP, chat with participants when applicable). The click MUST NOT leave the calendar view solely to open a meeting chat. Opening the meeting chat remains available from the detail dialog or the event context menu when a meeting chat exists.

#### Scenario: Open timed event details

- **WHEN** the user clicks a timed event in the week or day grid
- **THEN** an event detail dialog opens for that event
- **AND** the calendar view remains the active section behind the dialog

#### Scenario: Open all-day event details

- **WHEN** the user clicks an all-day chip in the all-day row
- **THEN** the same style of event detail dialog opens for that event

### Requirement: Week grid refresh keeps visible events

The agenda calendar poll MUST NOT replace the week or month grid event list with the shorter agenda fetch window. Deleting one event or scrolling the calendar MUST NOT make other still-valid events disappear from the grid. Multi-day all-day events rendered on several day columns MUST use distinct UI element identities per day so re-renders keep every chip visible.

#### Scenario: Delete does not wipe sibling events

- **WHEN** the user deletes one event from the detail dialog
- **THEN** other events in the visible week or month remain in the grid
- **AND** a subsequent agenda poll does not remove earlier days of the open week solely because they fall outside the agenda window

#### Scenario: Multi-day all-day chips survive scroll

- **WHEN** an all-day event spans multiple days in the week grid
- **THEN** each day column keeps its chip after scrolling or re-rendering

### Requirement: Join Teams meeting from calendar

When a calendar event carries a Teams join URL, the app SHALL offer a Join action in the event detail dialog and on the timed calendar block itself. Join MUST be available whenever the link is present and the event is not cancelled, not only inside the pre-start join window used for reminders.

#### Scenario: Join from event detail

- **WHEN** the user opens an event that has a Teams join URL
- **THEN** the detail dialog shows a Join button
- **AND** choosing Join starts joining that meeting

#### Scenario: Join from calendar block

- **WHEN** a timed calendar block has a Teams join URL
- **THEN** the block shows a Join control
- **AND** choosing Join starts joining without requiring the detail dialog

### Requirement: Delete calendar event from detail

The event detail dialog SHALL offer a Delete action that removes the event from its owning calendar source and from the visible grid. Outlook-sourced events use the mailbox delete path. Google-sourced events use Google Calendar delete and honour the user's choice to notify organizers/attendees when that choice exists for responses. A failed delete MUST restore the event in the grid and show an error.

#### Scenario: Delete a Google event

- **WHEN** the user deletes a Google-sourced event from the detail dialog
- **THEN** the event is removed from that Google calendar
- **AND** it disappears from the week or day grid after a successful delete

#### Scenario: Delete an Outlook event

- **WHEN** the user deletes an Outlook-sourced event from the detail dialog
- **THEN** the event is removed through the Outlook path
- **AND** it disappears from the week or day grid after a successful delete
