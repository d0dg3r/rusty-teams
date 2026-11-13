# Design

## Context

Siehe `proposal.md` — Why. Heute: Poll in `crates/app-state/src/backend.rs` (`calendar_loop`) lädt nur `chatsvc::Calendar` (Teams MT `calendarView`). Anlegen und RSVP gehen über Graph `POST /me/events` bzw. accept/decline in `crates/chatsvc/src/calendar/schedule.rs`. Erinnerungen über Graph `reminderView` / snooze / dismiss in `reminders.rs`. Meet now ohne Postfach: Teams Scheduling-API in `calendar.rs` (`create_meet_now`). UI: `crates/app/src/views/calendar_view.rs`, New-Meeting-Dialog, Settings-Abschnitte unter `crates/app-state` / `crates/app`.

## Goals / Non-Goals

**Goals:**

- Provider-Schnittstelle über Outlook und Google, Merge im Poll, Heim-Kalender + optionale Schreibziele.
- Google OAuth Desktop, Tokens lokal, Polling statt Push-Webhook.
- Create: Teams-Join-Link zuerst (Graph `onlineMeetings` oder bestehende Scheduling-API), dann Insert je Schreibziel.
- RSVP und Reminder nach Event-Quelle routen; Google-Snooze lokal.

**Non-Goals:**

- Gmail, Google Drive, Google Meet als Konferenz-Provider.
- Öffentlicher Webhook / Google push sync channel.
- Vollständige Sync-Engine (Offline-Queue über App-Neustart hinaus für Google-Writes — genug ist Best-Effort + Fehler anzeigen).
- Upstream-PR an `danieldaeschle/rusty-teams` in diesem Change.

## Decisions

### 1. Capability-Modell: Accounts + Calendars, nicht «Google-only»-API in der UI

- **Choice:** Persistenz und Settings sprechen von Account (Microsoft mailbox vs Google account) und Calendar-IDs (primary / secondary). Heim-Kalender und Schreibziele sind IDs dieses Modells.
- **Why:** Später weitere Provider ohne Dialog-Umbau.
- **Alternative:** Nur «Google an/aus» — verworfen wegen «später mehr Kalender».

### 2. OAuth: Google Desktop / loopback, Scope Kalender

- **Choice:** Authorization Code + PKCE (oder installierte Desktop-App), Scopes mindestens Kalender lesen/schreiben (`calendar.events` / `calendar` nach Bedarf). Refresh-Token unter App-Datenverzeichnis, getrennt vom MSAL-Cache.
- **Why:** Passt zu Desktop ohne Browser-Plugin; Linux-Sign-in bleibt Chrome für Microsoft.
- **Alternative:** Nur ICS-Subscribe read-only — deckt Schreiben nicht ab.

### 3. Read-Pfad: parallel pollen, dann mergen

- **Choice:** `calendar_loop` **und** der Wochen-/Monats-Load (`load_calendar_week`) holen Outlook (wenn ausgewählt; Fehler nicht fatal wenn Google da) und Google `events.list` für gewählte Kalender im gleichen Zeitfenster; Merge nach `ical_uid` bzw. normalisiertem Teams-Join-URL; `CalendarEvent` um `source` / Account- und Calendar-ID erweitern. Poll-Ergebnisse fliessen auch in das sichtbare Raster (nicht nur Agenda).
- **Why:** UI bleibt ein Raster; Dedup vermeidet Doppelblöcke bei «beide schreiben». Nur Graph in der Week-View war ein Loch — Google blieb unsichtbar.
- **Alternative:** Zwei getrennte Raster — schlechter UX.

### 4. Create-Pfad: Meeting-Link zuerst, dann Kalender-Inserts

```
New meeting
  -> resolve write targets (home + optional extras)
  -> create Teams online meeting (Graph onlineMeetings oder Scheduling-API)
  -> for each target:
       Outlook home/extra -> Graph POST /me/events with isOnlineMeeting
                            OR patch body with join URL if meeting already created
       Google target      -> events.insert with location/description = join URL,
                            attendees, RRULE from dialog Repeat
  -> surface join URL even if a secondary insert fails
```

- **Why:** Google kann kein `teamsForBusiness` ausstellen; ohne Postfach scheitert der heutige Ein-Schritt-Graph-POST.
- **Alternative:** Nur Graph `isOnlineMeeting` und Google als Kopie danach — bricht ohne Mailbox.

Wenn Heim-Kalender Outlook ist und keine Extra-Ziele: heutiger Ein-Schritt-Pfad darf bleiben (weniger Roundtrips).

### 5. RSVP / Reminders

- **RSVP:** An `source` entscheiden — Outlook: `Calendar::respond`; Google: `events.patch` `attendees[].responseStatus` + `sendUpdates`.
- **Reminders / Start-Notifications:** Gleiches Toast-Modell für Outlook und Google (Soon ≈ 5 Min vorher, Started, Live; Join / Snooze / Dismiss / Chime). Outlook weiter über Graph `reminderView` (Snooze/Dismiss schreiben dorthin). Google: lokale Phasen aus Event-Start/`join_url`; Outlook-`allows`-Gate gilt **nur** für Outlook-Events (sonst wurden Google-Toasts unterdrückt, sobald ReminderView geladen war). Reminder-Tick liest Agenda **und** Wochenraster (Dedup). Google-Snooze/Dismiss bleiben lokal.

### 6. Settings UI und Kalenderliste in der Ansicht

- Abschnitt «Calendar» / «Kalenderkonten»: Connect Google, Disconnect, Liste Kalender (primary vorselektiert), Heim-Kalender-Dropdown, Checkboxen «auch schreiben nach …».
- **Calendar-View:** linke Liste «CALENDARS» mit Outlook + jedem Google-Kalender (An/Aus), analog Teams — ohne Settings öffnen zu müssen.
- New-meeting-Dialog: Schreibziele aus Settings als Default, optional Override nur wenn nötig (Default: Settings reichen).

### 6b. All-day-Darstellung und Event-Detail

- Google liefert Feiertage/Wochenmarker oft als `dateTime` 00:00→00:00 (lokale Mitternacht) statt `date`. Das Raster behandelt diese wie `all_day`: nur All-day-Zeile, kein Vollhöhen-Block im Stundenraster (`is_effective_all_day` mit lokalem Offset; auch Mehr-Tage 00:00→23:59).
- Klick auf einen Block (timed oder all-day) öffnet einen **Event-Detail-Dialog** (Zeit, Quelle, Organizer, Join/RSVP/Chat/**Delete**). Kein automatischer Wechsel in den Meeting-Chat — der liess Google-Termine «verschwinden» bzw. öffnete nie die Details. Chat bleibt Kontextmenü / Dialog-Button.
- **Join:** Sobald ein Teams-Join-Link am Event hängt (`online` + URL), erscheint **Join** im Detail-Dialog und am timed Kalenderblock — unabhängig vom Join-Zeitfenster (das Fenster gilt weiter für Reminder/Toasts).
- **Delete:** Optimistic Remove aus dem Raster; Outlook `DELETE /me/events/{id}` (iCal-UID-Fallback wie RSVP); Google `events.delete` mit `sendUpdates` analog RSVP. Bei Fehler Restore + Notice.
- **Raster-SoT:** `load_calendar_week` füllt `calendar_week.events`. Der Agenda-Poll (`apply_calendar`) schreibt nur `calendar_events` und darf das Wochen-/Monatsraster nicht mit dem kürzeren Agenda-Fenster überschreiben (sonst verschwinden z. B. Mo/Di nach Delete/Poll). GPUI-Element-IDs sind tag-qualifiziert (`object_id` + Datum), damit Mehr-Tage-All-day-Chips beim Scrollen nicht kollidieren.

### 7. Lieferung

- Entwicklung und Release auf Remote `fork` (`d0dg3r/rusty-teams`). Kein Riesen-Upstream-PR.

## Risks / Trade-offs

- [Google OAuth Client-Registrierung / Verification] → Desktop-Client im Google Cloud Projekt des Forks; Secrets nicht committen, Config über Env/Build-Flag dokumentieren.
- [Doppel-Events trotz Merge] → Merge-Keys (iCal UID, Join-URL) unit-testen; bei nur Titel/Zeit vorsichtig nicht auto-mergen.
- [Create: Meeting existiert, Insert fehlgeschlagen] → Join-Link trotzdem anzeigen; Fehlertext welches Ziel fehlschlug; Poll räumt keine Geister-Meetings auf (onlineMeeting bleibt).
- [Token-Diebstahl lokal] → gleiche Schutzklasse wie MSAL-Cache; kein Sync in Cloud.
- [Rate limits Google] → gleiches Fenster wie heutiger Poll; Backoff bei 429.

## Migration Plan

- Feature hinter verbundenem Google-Konto: ohne Verbindung unverändert Outlook-only.
- Bestehende Nutzer: Heim-Kalender default = Outlook wenn Mailbox ok, sonst erster Google-Kalender nach Connect.
- Rollback: Disconnect Google + Feature-Flag/Build ohne Google-Client-ID → alter Pfad.

## Open Questions

- Exakte Google OAuth Client-Bereitstellung für den Fork-Build (welche Client-ID-Quelle zur Compile-Zeit) — ändert nicht die Specs, nur Packaging.
- Ob sekundäre Google-Kalender (nicht primary) im ersten Slice schon verbindbar sind oder nur primary + später Liste — Spec erlaubt Liste; Implementierung kann primary zuerst shippen und weitere Kalender im selben Settings-UI nachziehen.
