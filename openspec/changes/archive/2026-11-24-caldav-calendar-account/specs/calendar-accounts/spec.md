## ADDED Requirements

### Requirement: Connect CalDAV calendar account

The app SHALL let the user connect a CalDAV account with a server URL, username, and app password, and keep that connection on the device until the user disconnects. Disconnecting MUST stop reading and writing that account's calendars and MUST remove its app password from the device keyring. Connect MUST use HTTP Basic authentication. The app password MUST live only in the OS keyring.

#### Scenario: Connect CalDAV

- **WHEN** the user enters a CalDAV URL, username, and app password and chooses Connect
- **THEN** the app discovers or lists calendars that support events
- **AND** the connected account appears among calendar accounts
- **AND** the app password is stored only in the OS keyring

#### Scenario: Disconnect CalDAV

- **WHEN** the user disconnects a connected CalDAV account
- **THEN** its events leave the calendar grid on the next refresh
- **AND** it is no longer offered as home calendar or write target
- **AND** its app password is removed from the keyring

#### Scenario: Digest auth refused

- **WHEN** Connect reaches a server that answers with Digest authentication
- **THEN** Connect fails
- **AND** the error states that Digest authentication is not supported

#### Scenario: HTTPS downgrade refused

- **WHEN** discovery or Connect follows a redirect from HTTPS to HTTP
- **THEN** Connect fails
- **AND** the app password is not sent over HTTP

### Requirement: CalDAV calendars in the picker and grid

The calendar list SHALL include each connected CalDAV calendar that supports events so the user can show or hide it. Read-only calendars MAY appear in the list but MUST NOT be choosable as home calendar. Selected CalDAV events MUST appear in the same week and month grid as Outlook and Google, with duplicates collapsed by iCal UID or Teams join URL.

#### Scenario: Toggle CalDAV calendar in the picker

- **WHEN** the user turns a connected CalDAV calendar on in the calendar list
- **THEN** its events appear in the week or month grid after refresh
- **AND** turning it off removes those events on the next refresh

#### Scenario: CalDAV only without mailbox

- **WHEN** the Teams/Outlook calendar fails or is empty and a CalDAV calendar is connected
- **THEN** the grid still shows the CalDAV events
- **AND** the app does not leave the calendar unusable solely because Outlook failed

#### Scenario: Duplicate with Outlook prefers Outlook

- **WHEN** the same meeting exists in Outlook and CalDAV with the same iCal UID or Teams join URL
- **THEN** the grid shows one block
- **AND** RSVP and delete target the Outlook copy

### Requirement: CalDAV home calendar and New meeting

The user SHALL be able to choose a writable CalDAV calendar as home calendar. «New meeting» MUST write to that home calendar and MAY write to additional selected targets. When any write target is not Outlook, the app MUST create the Teams join link first. Only one target SHALL send invitations: Outlook when it is among the write targets; otherwise CalDAV alone.

#### Scenario: Home is CalDAV without mailbox

- **WHEN** the home calendar is a writable CalDAV calendar and Outlook create is unavailable
- **THEN** «New meeting» still creates the Teams join link
- **AND** stores the meeting in the selected CalDAV calendar with that join link

#### Scenario: Outlook invites when both are write targets

- **WHEN** the user creates a meeting with Outlook and a CalDAV calendar as write targets
- **THEN** Outlook sends the attendee invitations
- **AND** the CalDAV copy stores the meeting without a separate invitation send from CalDAV

### Requirement: RSVP and delete for CalDAV events

Accept, tentatively accept, and decline for a CalDAV-owned invitation MUST update the user's attendee response on that event. When the server does not advertise scheduling outbox support, the app MUST treat the response as saved locally and MUST NOT claim organizers were notified. Delete of a single CalDAV event MUST remove that event. Delete of one occurrence of a series MUST exclude that occurrence without deleting the whole series. Read-only CalDAV calendars MUST NOT offer RSVP or delete.

#### Scenario: Decline a CalDAV invitation without scheduling

- **WHEN** the user declines a CalDAV-sourced invitation and the server has no schedule outbox
- **THEN** the local attendee response becomes declined
- **AND** the UI does not claim organizers were emailed

#### Scenario: Delete one occurrence of a CalDAV series

- **WHEN** the user deletes a single occurrence of a CalDAV series
- **THEN** the app excludes that occurrence with EXDATE on the series master
- **AND** the app does not DELETE the series resource href
- **AND** that occurrence no longer appears in the grid after refresh
- **AND** other occurrences of the series remain

#### Scenario: Series occurrences keep distinct object ids

- **WHEN** a CalDAV or ICS series expands into more than one occurrence in the visible window
- **THEN** each occurrence has a distinct `object_id` that includes the occurrence start
- **AND** peek, selection, reminders, and retained peek details address one occurrence at a time

### Requirement: CalDAV reminders stay local

Online CalDAV meetings with a Teams join URL SHALL raise the usual Soon, Started, and Live meeting toasts. Snooze and dismiss MUST stay in the app and MUST NOT write to Outlook ReminderView for CalDAV-sourced events.

#### Scenario: Snooze CalDAV reminder locally

- **WHEN** the user snoozes a CalDAV-sourced meeting reminder
- **THEN** the toast is cleared locally for the Soon phase without writing to Outlook ReminderView

### Requirement: Polling CalDAV without push

Calendar updates from CalDAV SHALL be discovered by polling on an interval comparable to the existing calendar refresh. The app MUST NOT require a public webhook for CalDAV.

#### Scenario: External CalDAV change appears after poll

- **WHEN** an event is added or changed on the CalDAV server outside the app
- **THEN** the next successful calendar poll updates the grid accordingly

### Requirement: CalDAV load failures surface

When CalDAV is connected and the week or month load cannot authenticate or complete the query, the app MUST report a CalDAV calendar load failure with a banner and retry. A CalDAV failure MUST NOT clear successfully loaded Outlook or Google events from the grid. A fetch MUST NOT overwrite calendar toggles the user made while the fetch was running.

#### Scenario: CalDAV auth failure keeps other sources

- **WHEN** CalDAV returns unauthorized during week load and Outlook events loaded successfully
- **THEN** the grid still shows the Outlook events
- **AND** a CalDAV load failure is shown with retry

#### Scenario: One CalDAV calendar fails while another succeeds

- **WHEN** one selected CalDAV calendar fails during week load and another selected CalDAV calendar succeeds
- **THEN** the grid still shows events from the successful CalDAV calendar
- **AND** a CalDAV load failure names the failed calendar

#### Scenario: CalDAV or ICS request times out

- **WHEN** a CalDAV or ICS host does not answer within the request timeout
- **THEN** that source fails with a load failure
- **AND** other calendar sources that already loaded keep their events

### Requirement: ICS read-only subscriptions

The app SHALL let the user add a read-only ICS subscription by URL and optional display name. Subscribed events MUST appear in the merged grid and MUST NOT offer create, edit, RSVP, or delete. `webcal://` and `webcals://` URLs MUST be stored and fetched as `https://`.

#### Scenario: Add ICS subscription

- **WHEN** the user enters an ICS URL and chooses to subscribe
- **THEN** the subscription appears among calendar accounts
- **AND** its events appear in the week or month grid after refresh as read-only

#### Scenario: webcal URL normalised

- **WHEN** the user pastes a `webcal://` or `webcals://` subscription link
- **THEN** the app stores and fetches it as `https://`
- **AND** events load when the HTTPS feed succeeds

#### Scenario: One ICS subscription fails while another succeeds

- **WHEN** one selected ICS subscription fails during week load and another selected ICS subscription succeeds
- **THEN** the grid still shows events from the successful subscription
- **AND** an ICS load failure names the failed subscription

## MODIFIED Requirements

### Requirement: Home calendar and write targets

The user SHALL choose one home calendar among available calendars (Outlook mailbox, a connected Google calendar, or a writable connected CalDAV calendar). «New meeting» MUST always write to the home calendar. The user MAY select additional write targets so the same meeting is also created there. The set of targets MUST be extensible when more calendar accounts are added later. A successful New meeting create MUST show the meeting in the calendar grid after the next refresh for each write target that accepted the create. When any selected write target is not Outlook, the app MUST mint the Teams join link before writing to those targets.

#### Scenario: Write to home only

- **WHEN** the user creates a new meeting with only the home calendar selected
- **THEN** the meeting is created in that home calendar
- **AND** it is not created in other calendars
- **AND** it appears in the grid after the next refresh

#### Scenario: Write to home and another calendar

- **WHEN** the user creates a new meeting with the home calendar and an additional write target selected
- **THEN** the meeting is created in each selected calendar
- **AND** each created event carries the Teams join link when the meeting is online

#### Scenario: Home is Google without mailbox

- **WHEN** the home calendar is a Google calendar and Outlook create is unavailable
- **THEN** «New meeting» still creates the Teams join link
- **AND** stores the meeting in the selected Google calendar with that join link

#### Scenario: Home is CalDAV without mailbox

- **WHEN** the home calendar is a writable CalDAV calendar and Outlook create is unavailable
- **THEN** «New meeting» still creates the Teams join link
- **AND** stores the meeting in the selected CalDAV calendar with that join link

### Requirement: Merged calendar grid from connected accounts

The app SHALL show events from the Teams/Outlook calendar (when available and selected), from each selected Google calendar, and from each selected CalDAV calendar in the same week and month views. The week and month grid load MUST include those sources. Events that represent the same meeting MUST appear once, using matching iCal UID or the same Teams join URL when present. Each visible block MUST indicate its calendar source. When Outlook and another source contribute to the same meeting, Outlook MUST own RSVP and delete for that block.

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

#### Scenario: CalDAV in the merged grid

- **WHEN** a CalDAV calendar is selected together with Outlook or Google
- **THEN** its events appear in the same grid
- **AND** duplicates by iCal UID or Teams join URL collapse to one block

### Requirement: RSVP follows event source

Accept, tentatively accept, and decline MUST target the calendar that owns the selected event. Outlook events use the existing mailbox response path. Google events update the user's response on that Google event and honour the user's choice to send or not send a response to organizers. CalDAV events update the user's attendee response on that CalDAV event; organizer notification follows only when the server supports scheduling.

#### Scenario: Decline a Google invitation

- **WHEN** the user declines a Google-sourced invitation with «Send a response» on
- **THEN** the Google event response becomes declined
- **AND** organizers are notified according to Google's send-updates behaviour

#### Scenario: Accept an Outlook invitation

- **WHEN** the user accepts an Outlook-sourced invitation
- **THEN** the response is written through the Outlook path as today

#### Scenario: Accept a CalDAV invitation

- **WHEN** the user accepts a CalDAV-sourced invitation
- **THEN** the response is written on that CalDAV event

### Requirement: Reminder actions by source

Snooze and dismiss for Outlook-sourced reminders MUST continue to write to Outlook. For Google-sourced and CalDAV-sourced reminders, dismiss MAY clear the toast without requiring an Outlook write; snooze MUST stay in the app because those sources do not offer Outlook-style absolute snooze.

#### Scenario: Snooze Outlook reminder

- **WHEN** the user snoozes an Outlook meeting reminder
- **THEN** the snooze is stored on the Outlook reminder as today

#### Scenario: Snooze Google reminder locally

- **WHEN** the user snoozes a Google-sourced meeting reminder
- **THEN** the toast is cleared locally for the Soon phase without writing to Outlook ReminderView
- **AND** the toast may return when the meeting reaches Started if still eligible

#### Scenario: Snooze CalDAV reminder locally

- **WHEN** the user snoozes a CalDAV-sourced meeting reminder
- **THEN** the toast is cleared locally for the Soon phase without writing to Outlook ReminderView

### Requirement: Meeting start notifications for calendar sources

Online meetings with a Teams join URL from Outlook, Google, or CalDAV SHALL raise the usual meeting reminder toast: about five minutes before start (Soon), when the meeting has started (Started), and Live when the meeting chat is already running. The toast MUST offer Join, and for Soon also Snooze; Dismiss and a start chime MUST work as for Outlook meetings. Non-Outlook meetings MUST NOT be suppressed merely because the Outlook reminder view is loaded.

#### Scenario: Google meeting soon toast

- **WHEN** a Google-sourced online meeting with a Teams join URL starts within the lead window
- **THEN** a meeting toast appears with Join and Snooze
- **AND** a start chime may fire when the meeting reaches Started or Live

#### Scenario: Google toast after Outlook reminder poll

- **WHEN** Outlook ReminderView has already been loaded for nearby meetings
- **THEN** an eligible Google meeting in the same window still shows its toast
- **AND** Outlook meetings continue to honour ReminderView fire times

#### Scenario: CalDAV meeting soon toast

- **WHEN** a CalDAV-sourced online meeting with a Teams join URL starts within the lead window
- **THEN** a meeting toast appears with Join and Snooze

### Requirement: Load state and source errors

The calendar SHALL show that the visible range is loading. When a selected source fails to load, the calendar MUST show an inline notice naming that source with a Retry action, for every failed load rather than once per session. Events from sources that loaded MUST still show. Google token refresh failures and CalDAV authentication or query failures MUST surface as load failures, not as a silent empty grid for that source.

#### Scenario: Outlook fails, Google loads

- **WHEN** Outlook fails to load the visible week and a Google calendar loads
- **THEN** the Google events show in the grid
- **AND** a notice says Outlook could not be loaded and offers Retry

#### Scenario: Retry succeeds

- **WHEN** the user chooses Retry and Outlook loads
- **THEN** the notice disappears and the Outlook events show

#### Scenario: CalDAV fails, Outlook loads

- **WHEN** CalDAV fails during week load and Outlook succeeds
- **THEN** the grid shows Outlook events
- **AND** a notice names CalDAV and offers Retry
