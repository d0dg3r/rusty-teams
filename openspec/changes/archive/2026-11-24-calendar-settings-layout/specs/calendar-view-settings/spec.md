## MODIFIED Requirements

### Requirement: Default calendar view

Settings › Calendar SHALL offer a Default view with the choices Last used, Day, Work week, Week and Month. Last used MUST be the default. Opening the calendar after a restart MUST show the chosen span; with Last used it MUST show the span the user chose last. Settings › Calendar MUST contain view layout preferences only and MUST NOT host calendar account connect forms.

#### Scenario: Last used survives a restart

- **WHEN** Default view is Last used and the user switches the calendar to Month, then restarts the app and opens the calendar
- **THEN** the calendar opens in Month

#### Scenario: Fixed default view

- **WHEN** Default view is Week and the user switches the calendar to Day, then restarts the app and opens the calendar
- **THEN** the calendar opens in Week

#### Scenario: Day opened from a month cell is temporary

- **WHEN** the user clicks a day in the month grid, which opens that day in Day, and Default view is Last used
- **THEN** the remembered span stays the one the user last chose from the view menu

#### Scenario: Calendar section is view-only

- **WHEN** the user opens Settings › Calendar
- **THEN** the page shows default view, first day, work days and hours, time scale, and weekend work-week behaviour
- **AND** it does not show Google, CalDAV, or ICS connect forms

### Requirement: Work days and hours follow the mailbox

The calendar SHALL take work days and work start and end from the Outlook mailbox working hours. Settings › Calendar MUST show them and MUST save changes back to the mailbox working hours, so Outlook and Teams see the same values. When the mailbox cannot be read, Monday to Friday 08:00–17:00 MUST apply.

#### Scenario: Mailbox values apply

- **WHEN** the mailbox working hours are Monday to Friday 08:00–17:00
- **THEN** Work week shows Monday to Friday
- **AND** hours before 08:00 and from 17:00 are shaded as outside work time

#### Scenario: Change saved to the mailbox

- **WHEN** the user turns Friday off as a work day in Settings › Calendar
- **THEN** the mailbox working hours no longer list Friday
- **AND** Work week shows Monday to Thursday

#### Scenario: Save fails

- **WHEN** saving the working hours to the mailbox fails
- **THEN** the setting shows the previous value again
- **AND** the app shows a notice that the change was not saved

### Requirement: First day of week

The first day of week SHALL default to the one of the mailbox language's region, as Outlook does, and to the regional format when the mailbox language is unknown. Settings › Calendar MUST offer an override with Monday, Sunday or Saturday. Week, Work week, Month and the mini month MUST start their weeks on that day.

#### Scenario: Default follows the mailbox language

- **WHEN** the mailbox language is en-CH, the regional format is en-US and no override is set
- **THEN** weeks start on Monday

#### Scenario: Sunday start

- **WHEN** the first day of week is Sunday and the user opens Week on Wednesday 2026-11-18
- **THEN** the grid shows Sunday 2026-11-15 to Saturday 2026-11-21

#### Scenario: Month grid follows the first day

- **WHEN** the first day of week is Sunday and the user opens Month
- **THEN** the weekday header starts with Sunday

### Requirement: Time scale

Settings › Calendar SHALL offer a time scale of 15, 30 or 60 minutes, with 30 as the default. The hour grid MUST draw one minor line per time-scale step and size its rows to the step.

#### Scenario: Thirty minute scale

- **WHEN** the time scale is 30 minutes
- **THEN** each hour shows one full line at the hour and one minor line at the half hour

#### Scenario: Fifteen minute scale

- **WHEN** the user changes the time scale to 15 minutes
- **THEN** each hour shows three minor lines and the rows grow taller

### Requirement: Work week on a non-work day

Settings › Calendar SHALL offer what Work week shows when today is not a work day: next week (default) or this week.

#### Scenario: Next week on Sunday

- **WHEN** today is Sunday 2026-11-15, the setting is next week and the user chooses Today in Work week
- **THEN** the grid shows the work days of the week starting Monday 2026-11-16

#### Scenario: This week on Sunday

- **WHEN** today is Sunday 2026-11-15, the setting is this week and the user chooses Today in Work week
- **THEN** the grid shows the work days of the week starting Monday 2026-11-09
