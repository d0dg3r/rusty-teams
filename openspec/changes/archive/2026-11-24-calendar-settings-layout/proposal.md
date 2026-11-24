## Why

Calendar settings put view prefs, Google, CalDAV, and ICS connect forms on one page. Bare text inputs inside horizontal `control_row` squeeze titles to zero width so labels wrap one letter per line. The page is too long to use safely.

## What Changes

- Split Settings into **Calendar** (view prefs only) and **Calendar accounts** (sources, home, write).
- Stack long text fields (URL, username, password, ICS URL/name) above the control so titles stay readable.
- Keep CalDAV and ICS connect forms collapsed until the user chooses to add; Google connect stays as today.
- Make dual-write / home copy source-neutral (not Google-only).
- «Add calendar» in the calendar picker opens Calendar accounts.

## Capabilities

### Modified Capabilities

- `calendar-view-settings`: Settings › Calendar holds view prefs only; navigation wording stays Calendar.
- `calendar-accounts`: Settings › Calendar accounts holds connect, home, and write; stacked fields; collapsed add forms.

## Impact

- Settings nav enum and dialog routing (`SettingsSection::CalendarAccounts`).
- `crates/app/src/settings/{calendar,caldav_form,rows,nav,dialog}.rs`, locales, calendar picker deep-link, layout_guard section list.
- No CalDAV protocol or sync behaviour change.
