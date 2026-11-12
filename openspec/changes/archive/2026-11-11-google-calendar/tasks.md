# Tasks

## 1. Modell und Persistenz

- [x] 1.1 Account-/Kalender-Modell (Microsoft-Mailbox vs Google-Account, Calendar-IDs, Heim-Kalender, Schreibziele) und lokale Persistenz anlegen; Verify: Unit-Tests für Serialisieren/Defaults (`cargo test -p store --lib` bzw. neues Modul-Filter)
- [x] 1.2 `CalendarEvent` um Quelle und Account-/Calendar-ID erweitern, ohne bestehende Parser-Fixtures zu brechen; Verify: `cargo test -p chatsvc --lib calendar`

## 2. Google Auth und API-Client

- [x] 2.1 Google OAuth Desktop (Code + PKCE), Token speichern/löschen, Client-ID-Quelle dokumentieren; Verify: Unit-Tests für State/Token-Roundtrip ohne Netz, Doku-Abschnitt im Fork-README oder Settings-Hinweis
- [x] 2.2 Google Calendar Client: Kalenderliste, `events.list` im Zeitfenster, Parse → `CalendarEvent`; Verify: `cargo test` auf Parser-Fixtures (Fixtures aus API-Beispielen)
- [x] 2.3 Google Write: `events.insert` (Join-Link in Ort/Beschreibung, Attendees, RRULE aus Repeat) und RSVP-Patch mit sendUpdates; Verify: Body-Builder Unit-Tests analog `new_event_body`

## 3. Poll, Merge, Create-Routing

- [x] 3.1 Merge-Logik (iCal-UID, normalisierter Teams-Join-URL) und Quellen-Labels; Verify: dedizierte Unit-Tests für Dedup und Nicht-Dedup bei nur Titel/Zeit
- [x] 3.2 `calendar_loop` parallel Outlook + Google pollen; Outlook-Fehler nicht fatal wenn Google verbunden; Verify: `cargo test -p app-state --lib` für Loop-/Merge-Hilfen wo isolierbar, sonst Fixture-Tests der Merge-API
- [x] 3.3 Create-Pfad: Teams-Join-Link zuerst, dann Inserts je Schreibziel; Outlook-only Home behält bestehenden Graph-Ein-Schritt; Verify: Unit-Tests für Zielauswahl und Fehler «ein Ziel fehlgeschlagen, Link trotzdem da»
- [x] 3.4 RSVP und Reminder nach Quelle routen; Google-Snooze lokal; Verify: `cargo test -p app-state --lib` Reminder-/RSVP-Filter + `cargo test -p chatsvc --lib` bestehende Outlook-Reminder-Tests grün

## 4. UI

- [x] 4.1 Settings: Google verbinden/trennen, Kalenderliste, Heim-Kalender, zusätzliche Schreibziele; Verify: Layout-/State-Tests oder manuelles Smoke-Protokoll im Task-Kommentar nach Demo-Lauf
  - Settings > Calendar UI verdrahtet (Connect/Disconnect, Home, Also write). Live-Connect braucht `TEAMS_GOOGLE_CLIENT_ID`.
- [x] 4.2 Kalenderblöcke Quelle anzeigen; New-Meeting nutzt Heim + Schreibziele; Verify: UI- bzw. State-Tests für Default-Ziele und Quellen-Anzeige wo vorhanden

## 5. Integration

- [ ] 5.1 End-to-end Smoke (manuell): Connect Google, Raster mit beiden Quellen, New meeting nur Heim, New meeting Heim+Google, RSVP Google, Snooze Google lokal; Verify: kurze Checkliste abgehakt, keine Regression Outlook-only ohne Google
  - Checkliste:
    - [ ] Outlook-only ohne Env: Raster und New meeting wie bisher
    - [x] Connect Google via Settings > Calendar
    - [ ] Raster zeigt Google + Outlook (Merge ohne Doppel bei gleicher iCal-UID)
    - [ ] New meeting nur Heim (Outlook)
    - [ ] New meeting Heim+Google Dual-Write
    - [ ] RSVP auf Google-Event
    - [ ] Snooze Google-Toast lokal (kein Graph-Fehler)
    - [ ] Google-Termin mit Teams-Link: Toast Soon/Started mit Join (nicht von Outlook ReminderView blockiert)
- [x] 5.2 ROADMAP-Zeilen zum Kalender um Google-Konten ergänzen; Verify: Eintrag beschreibt den Fork-Stand korrekt

## 6. Kalenderauswahl in der Ansicht (Nachzug)

- [x] 6.1 Wochen-/Monats-Load merged Outlook + Google (nicht nur Graph `calendar_view`); Verify: `cargo test -p app-state --lib` wo isolierbar + manuell Raster mit Google-Events
- [x] 6.2 Kalenderliste in der Calendar-View (Outlook + Google, An/Aus); Toggle refreshed Grid; Verify: UI-Smoke — Liste sichtbar, Toggle blendet Quelle ein/aus
- [x] 6.3 OpenSpec Spec/Proposal für Picker + Grid-Load nachziehen; Verify: Spec-Szenarien «Calendar picker» vorhanden
- [x] 6.4 Ganzägige / Mitternacht→Mitternacht-Events nur in der All-day-Zeile, nicht als Vollhöhen-Blöcke im Stundenraster; Verify: `cargo test -p app-call-model --lib week_grid` (inkl. `midnight_to_midnight_timed_events_sit_in_the_all_day_row`) + Release installiert
- [x] 6.5 Klick auf Kalenderblock öffnet Event-Detail-Dialog (nicht Chat-Wechsel / Verschwinden); All-day-Chips ebenfalls; Chat/Join nur über Dialog oder Kontextmenü; Verify: Dialog verdrahtet, Unit/Build grün; manuell ZHAW nach App-Neustart
- [x] 6.6 Event-Detail: Delete entfernt den Termin aus der Quelle (Outlook Graph DELETE / Google events.delete) und aus dem Raster; Verify: `cargo test -p chatsvc --lib delete_event` + Release installiert; manuell Delete auf Google-Termin nach Neustart
- [x] 6.7 Join-Button bei Teams-Link: im Event-Detail und am Kalenderblock (nicht nur im Join-Fenster kurz vor Start); Verify: Build+Install; Join nicht mehr an `join_available`-Fenster gebunden
- [x] 6.8 Raster-Refresh: Agenda-Poll darf `calendar_week.events` nicht überschreiben; Element-IDs pro Tag eindeutig (Mehr-Tage); Verify: Delete/Scroll lassen andere Termine sichtbar; `cargo check -p app-state`

## 7. Meeting-Start Notifications (Nachzug)

- [x] 7.1 Google-Termine nicht durch Outlook ReminderView unterdrücken (`allows` nur für Outlook); Reminder-Tick aus Agenda **und** Wochenraster; Verify: `cargo test -p app-state --lib google_events_stay_allowed`
- [x] 7.2 Spec/Design: Toast Soon/Started/Live + Join/Snooze/Dismiss/Chime auch für Google mit Teams-Link; Google-Snooze/Dismiss lokal; Verify: Spec-Szenarien «Meeting start notification»

## Workflow follow-up

- Nach Merge auf dem Fork: `/opsx-archive` für `google-calendar` (Delta nach `openspec/specs/calendar-accounts/`).
- Alltagskomits und Tags nach `fork` pushen, nicht nach `origin`.
