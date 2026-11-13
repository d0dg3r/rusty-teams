# Proposal

## Why

Ohne Exchange-Postfach bleibt der Kalender leer oder bricht beim Laden ab; wer zusätzlich Google nutzt, sieht dessen Termine in der App nicht. Die Kalenderansicht und «New meeting» hängen heute ausschliesslich an Teams/Outlook. Google als zweites Konto (und später weitere Kalender) macht den Kalender auch für Nutzer ohne Microsoft-365-Postfach nutzbar und erlaubt, beide Welten im selben Raster zu führen.

## What Changes

- Der Nutzer kann ein Google-Konto für den Kalender verbinden und wieder trennen (OAuth, Refresh-Token lokal).
- Das Wochen-/Monatsraster zeigt Termine aus Teams/Outlook und verbundenen Google-Kalendern; gleiche Termine werden zusammengeführt (iCal-UID oder gleicher Teams-Join-Link), Quellen bleiben erkennbar.
- Der Nutzer wählt einen Heim-Kalender (Outlook oder ein Google-Kalender) und optional zusätzliche Schreibziele; «New meeting» schreibt dorthin und legt den Teams-Join-Link an den Event.
- Zusagen/Ablehnen und Erinnerungs-Snooze/Dismiss gehen an die Quelle des Blocks; Google-Snooze/Dismiss bleiben lokal in der App (Google kennt Outlook-ReminderView nicht).
- **Meeting-Start-Notifications** (Toast Soon/Started/Live mit Join, Snooze, Dismiss, Chime) gelten auch für Google-Termine mit Teams-Join-Link — dieselbe UX wie bei Outlook.
- Vorbereitet auf weitere Kalenderkonten später: Heim-Kalender und Schreibziele sind nicht an «nur Google» gebunden.
- Kein **BREAKING** für bestehende Outlook-only-Nutzer: ohne Google-Verbindung bleibt das heutige Verhalten.

## Capabilities

### New Capabilities

- `calendar-accounts`: Mehrere Kalenderkonten (Teams/Outlook plus Google und später weitere), verbundene Quellen im Raster, Heim-Kalender und wählbare Schreibziele für neue Meetings, quellenspezifische Zusagen und Erinnerungen.

### Modified Capabilities

- (keine)

## Impact

- UI: Einstellungen für Google-Verbindung, Heim-Kalender und Schreibziele; **Kalenderansicht mit Kalenderliste** (Outlook + Google, An/Aus wie in Teams); Kalenderblöcke mit Quelle; **All-day-Zeile** für ganztägige und Mitternacht→Mitternacht-Events; **Event-Detail-Dialog** beim Klick (statt Chat-Wechsel) inkl. **Delete** und **Join** bei Teams-Link; Join auch am Kalenderblock; Dialog «New meeting» schreibt nach gewählten Zielen. Das Wochen-/Monatsraster lädt und zeigt alle ausgewählten Quellen (nicht nur Outlook).
- Backend: Polling mehrerer Quellen, Merge, Create/RSVP/Reminder-Routing; Google Calendar API + OAuth neben MSAL/Graph.
- Secrets: Google OAuth Client-ID/-Secret bzw. Desktop-App-Flow; Tokens lokal neben dem Microsoft-Cache.
- Fork-Release: Feature auf `fork` (`d0dg3r/rusty-teams`); kein Upstream-PR mit dem ganzen Stack nötig.
