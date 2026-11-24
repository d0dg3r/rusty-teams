## 1. Layout helper

- [x] 1.1 Add `stacked_field` to settings `rows.rs` (title, optional detail, full-width control)
- [x] 1.2 Switch CalDAV/ICS URL, username, password, and display-name inputs to `stacked_field`

## 2. Nav split

- [x] 2.1 Add `SettingsSection::CalendarAccounts`; extend `TEAMS_GROUP`, nav label/icon/id/search terms, locales
- [x] 2.2 Split `calendar.rs` into view vs accounts render; mount CalDAV form only on accounts in `dialog.rs`
- [x] 2.3 Update exhaustive matches (`layout_guard` SETTINGS_SECTIONS) and picker deep-link to Calendar accounts

## 3. Collapse forms and copy

- [x] 3.1 CalDAV/ICS forms start collapsed; add buttons always visible; Google connect row unchanged
- [x] 3.2 Source-neutral dual-write / empty-write locale strings
- [x] 3.3 Nav unit test covers terms in `calendar.rs` and `caldav_form.rs`

## 4. Verify

- [x] 4.1 `cargo check -p app`
- [x] 4.2 OpenSpec tasks checked; `openspec validate calendar-settings-layout`
