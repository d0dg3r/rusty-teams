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

### Requirement: Grid load does not wait for calling

The week and month grid SHALL load Outlook events as soon as the signed-in session is available, independent of the calling service. A grid load that was skipped because no session was ready MUST run once the session becomes available.

#### Scenario: Calendar opened right after sign-in

- **WHEN** the user opens the calendar before the session is ready
- **THEN** the grid loads the visible range as soon as the session is ready, without further navigation

#### Scenario: Calling service still starting

- **WHEN** the session is ready but the calling service has not registered yet
- **THEN** Outlook events of the visible range still appear in the grid

### Requirement: Grid refresh while open

While the calendar view is open, the app SHALL reload the visible range on the calendar poll interval. A visible range that has already loaded MUST keep its events on screen until the reload replaces them.

#### Scenario: Change made elsewhere

- **WHEN** a meeting is added in Outlook for the visible week while the calendar is open
- **THEN** it appears in the grid after the next calendar poll

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

### Requirement: Calendar toggle survives a running fetch

Turning a calendar on or off SHALL stay in effect when a calendar fetch that started before the toggle completes. Only refreshed sign-in tokens from that fetch MUST be kept.

#### Scenario: Toggle during a fetch

- **WHEN** the user turns a Google calendar off while a calendar fetch is running
- **THEN** the calendar stays off after the fetch completes
- **AND** the check box does not flip back

### Requirement: RSVP from Upcoming meetings

Upcoming meeting rows that invite the user SHALL offer Accept, Tentative, and Decline (and a Respond menu with optional send-response), matching the peek RSVP controls. Own meetings where the user is the organizer MUST show Organizer instead of invitee RSVP controls. The response MUST follow the event source (Outlook Graph path or Google attendee status) as in RSVP follows event source.

#### Scenario: Accept from Upcoming

- **WHEN** the user accepts an Outlook invitation from an Upcoming row
- **THEN** the response is written through the Outlook path
- **AND** the row reflects the new response state after refresh

#### Scenario: Decline from Upcoming with send response

- **WHEN** the user declines a Google invitation from Upcoming with «Send a response» on
- **THEN** the Google event response becomes declined
- **AND** organizers are notified according to Google's send-updates behaviour

#### Scenario: Organizer row

- **WHEN** the Upcoming row is for a meeting the user organizes
- **THEN** the row shows Organizer
- **AND** invitee Accept / Tentative / Decline controls are not offered

### Requirement: Teams reminder push shares the poll toast path

When a Teams client push that announces an upcoming meeting reminder is proven (channel, payload, and meaning documented under research), the app SHALL start or refresh the same meeting reminder toast path used for `reminderView` polling: Soon / Started / Live phases, Join, Snooze on Soon, Dismiss, and start chime rules. The push MUST NOT invent a second toast UI. Until the push is proven, the app MUST keep discovering reminders by polling alone.

#### Scenario: Proven push triggers Soon toast

- **WHEN** a documented Teams reminder push arrives for an eligible online meeting before start
- **THEN** the meeting toast appears with Join and Snooze
- **AND** behaviour matches a toast raised from the reminder poll for the same meeting

#### Scenario: Unproven push stays unused

- **WHEN** research cannot identify the Teams reminder push payload
- **THEN** reminders continue to come from the calendar / ReminderView poll only
- **AND** the app does not subscribe to an invented push code

### Requirement: Google week-load auth failure is visible

When at least one Google account is connected and the calendar week load cannot obtain a usable Google access token (including a failed token refresh), the application MUST treat the Google source as failed for that load. The user MUST see the existing calendar source-failed notice for Google and MUST be able to retry. The application MUST NOT present a successful empty Google week when the only reason no Google events appear is an auth or refresh failure.

#### Scenario: Token refresh fails while Google is connected

- **WHEN** a Google account is connected and the week load needs to refresh the access token
- **AND** the refresh request fails (for example because the Desktop client secret is missing from the build)
- **THEN** the calendar shows a Google source-failed notice with retry
- **AND** the load is not reported as a successful Google week with zero events for that auth failure

#### Scenario: Events appear after a correct Desktop client build

- **WHEN** the release or local install includes both the project Desktop client id and client secret
- **AND** a Google account is connected with a valid refresh token
- **AND** the visible week range contains Google calendar events on selected calendars
- **THEN** those events appear in the calendar grid after a successful week load

### Requirement: Local Linux install bakes Desktop client secret

A local Linux install that compiles in `TEAMS_GOOGLE_CLIENT_ID` MUST also compile in a non-empty `TEAMS_GOOGLE_CLIENT_SECRET` from the environment or `.env.google.local`. If the secret is missing, the install MUST fail before replacing the installed binary. The install MUST verify the built binary contains the Google Desktop secret prefix without printing the secret value.

#### Scenario: Install refused without secret

- **WHEN** the operator runs the local Linux install script with a client id set and an empty or missing client secret
- **THEN** the script exits with a non-zero status and does not install a binary that can only Connect once before silent empty weeks

#### Scenario: Install with id and secret

- **WHEN** the operator runs the local Linux install script with both client id and client secret set
- **THEN** the installed binary can refresh Google tokens after Dock or desktop launch without requiring shell-exported credentials

### Requirement: Calendar accounts settings section

Settings SHALL offer a **Calendar accounts** navigation item separate from **Calendar**. That page SHALL host Google, CalDAV, and ICS account wiring, home calendar choice, and extra write targets. «Add calendar» in the calendar view picker MUST open Calendar accounts.

#### Scenario: Open Calendar accounts from settings nav

- **WHEN** the user opens Settings › Calendar accounts
- **THEN** the page shows connected sources, home calendar, and write targets
- **AND** view prefs such as default view are not on that page

#### Scenario: Picker add opens accounts

- **WHEN** the user chooses Add calendar in the calendar list
- **THEN** Settings opens on Calendar accounts

### Requirement: Stacked text fields for calendar credentials

CalDAV and ICS connect fields that take a URL, username, password, or display name SHALL place the field label above a full-width control. The label MUST remain readable on one horizontal line and MUST NOT wrap one character per line because a sibling input claimed the row width.

#### Scenario: Server URL label stays horizontal

- **WHEN** the CalDAV connect form is visible
- **THEN** the Server URL label reads left to right on one line
- **AND** the URL input spans the content width below the label

### Requirement: Collapsed CalDAV and ICS connect forms

The Calendar accounts page SHALL show CalDAV and ICS connect forms only after the user chooses to add that source. Add affordances MUST remain visible while forms are collapsed. Forms MUST start collapsed when the page opens.

#### Scenario: Forms start collapsed

- **WHEN** the user opens Settings › Calendar accounts
- **THEN** CalDAV URL, username, and password fields are hidden
- **AND** an action to connect CalDAV is visible

#### Scenario: Expand CalDAV form

- **WHEN** the user chooses to connect CalDAV
- **THEN** the CalDAV fields and connect action appear
- **AND** URL templates remain available in that form

### Requirement: Source-neutral dual-write copy

When home is not Outlook, Settings › Calendar accounts MUST describe the Outlook dual-write toggle without naming only Google as home. Empty extra-write hints MUST tell the user to connect another account when no Google or CalDAV account is connected, and MUST NOT tell them to connect Google when a CalDAV or Google account is already present.

#### Scenario: Dual-write when CalDAV is home

- **WHEN** home is a CalDAV calendar and Outlook dual-write is offered
- **THEN** the detail text does not claim dual-write applies only when home is Google

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
