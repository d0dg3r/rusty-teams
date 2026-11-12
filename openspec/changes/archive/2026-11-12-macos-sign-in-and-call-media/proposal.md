# Proposal

## Why

Auf macOS startet die App Chrome nicht selbst: ohne manuell geöffneten Debug-Port gibt es kein Anmelden. Bildschirmteilen fällt auf die Quellenliste, während ScreenCaptureKit den System-Dialog schon anbietet und die Liste leer lässt. Ton und Kamera laufen bereits über denselben Nicht-Windows-Pfad wie Linux; das Verhalten soll spezifiziert und Teilen sowie Login auf denselben Stand gebracht werden.

## What Changes

- Ohne `--endpoint` startet die App auf macOS Chrome oder Chromium mit Remote-Debugging und eigenem Profil, hält sie headless wenn angemeldet und zeigt das Fenster nur fürs Login — danach wieder im Hintergrund.
- Mit `--endpoint` dockt die App an eine bestehende Chrome-Instanz an und startet keine zweite verwaltete Instanz.
- Headless-User-Agent ist ein macOS-Chrome-String, kein Windows-NT-String.
- Auto und Low senden den CoreAudio-ADM-Mikrofontrack; Music-Mode, Off und Computer-Ton nutzen die Software-Kette. Auflegen beendet die Kette ohne den Client zu killen.
- Kamera-Vorschau und -Senden nutzen die Systemkamera; die Usage-Strings im `.app` bleiben Voraussetzung für die Systemdialoge.
- Bildschirmteilen auf macOS öffnet den ScreenCaptureKit-Dialog für Bildschirm oder Fenster, ohne Vorschauliste in der App. Abbruch bleibt still; fehlende Freigabe ist ein klarer Hinweis; das Gespräch bleibt verbunden.
- Windows und reines X11 behalten die bestehende Quellenliste.

## Capabilities

### New Capabilities

- `macos-sign-in`: Auf macOS startet und verwaltet die App Chrome/Chromium mit Remote-Debugging (eigener Profilordner), meldet sich darüber am Microsoft-Konto an und hält genau eine laufende App-Instanz.
- `macos-call-audio`: Auf macOS hören Gegenseite und lokaler Nutzer dieselbe Audio-Kette wie unter Linux (ADM für Auto/Low, Software für Music/Off/Computer-Ton), inklusive Kamera-Vorschau und -Senden über die Systemkamera.

### Modified Capabilities

- `screen-share`: Auf macOS öffnet Teilen den ScreenCaptureKit-System-Dialog statt einer leeren Quellenliste; Windows und reines X11 bleiben unverändert.

## Impact

- Browser-Start und Login-Fenster auf macOS (Profil unter Application Support, Chrome-Suche unter `/Applications`, `~/Applications` und PATH).
- Share-Picker und Start der lokalen Aufnahme in einem laufenden Gespräch auf macOS.
- README/Status-Zeile für macOS: von «connects to a Chrome» zu selbst gestartetem Chrome wie Linux.
- Lieferung auf dem Fork. Kein Upstream-PR, kein Windows-WebView2, kein eingebautes Login ohne Chrome, keine übrigen Roadmap-Lücken.
