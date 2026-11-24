## ADDED Requirements

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
