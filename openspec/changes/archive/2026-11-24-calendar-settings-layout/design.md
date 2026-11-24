## Context

`control_row` is a horizontal flex with a `flex_1 min_w(0)` title next to the control. `Input` uses `size_full()`, so it claims the row and squashes the title. Google/view rows use fixed-width buttons and selects, so they stay horizontal. Calendar settings grew into one scroll: view, Google, always-visible CalDAV/ICS forms, connected accounts, home, write.

## Goals / Non-Goals

**Goals:**

- Readable labels for URL and credential fields.
- Two nav sections so view prefs and account wiring are separate screens.
- Add CalDAV / ICS only after an explicit add action; forms start collapsed.

**Non-Goals:**

- New dialog surface or look tokens.
- Changing CalDAV/ICS sync, keyring, or merge rules.
- Sub-tabs inside a page or a third nav level.

## Decisions

1. **`stacked_field` in settings rows** — vertical title (+ optional detail) then full-width control. No new height literals; Input already sets `input_h` after `size_full`.
2. **`SettingsSection::CalendarAccounts`** — placed after Calendar in `TEAMS_GROUP`. Labels: en «Calendar accounts», de «Kalenderkonten».
3. **Page order on accounts** — per source: connected blocks, then connect/add affordance (form only when expanded); then Home; then Write. Google keeps its existing connect row.
4. **Picker deep-link** — `calendar.view.add_calendar` opens `CalendarAccounts`.
5. **Copy** — dual-write and empty-write hints speak of «home is not Outlook» / «connect another account», not Google-only.

## Risks / Trade-offs

- Extra nav item lengthens the settings list (acceptable; matches Chats/Calls density).
- Exhaustive `SettingsSection` matches must be updated or the build fails.

## Migration

- Existing users opening Settings › Calendar still see view prefs. Account work moves to the new section; search terms route to the right page.
