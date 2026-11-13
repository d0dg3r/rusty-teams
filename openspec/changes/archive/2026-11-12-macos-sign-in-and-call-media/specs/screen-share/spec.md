# Spec Delta

## ADDED Requirements

### Requirement: macOS öffnet den ScreenCaptureKit-Dialog

In einem verbundenen Gespräch auf macOS MUST die App den ScreenCaptureKit-System-Dialog öffnen. Sie MUST Quellen dort nicht selbst mit Vorschaubildern auflisten.

#### Scenario: Ganzer Bildschirm

- **WHEN** der Nutzer auf macOS den ganzen Bildschirm teilen wählt
- **THEN** öffnet das System einen Dialog für Monitore
- **AND** die App zeigt keine eigene Quellenliste mit Vorschaubildern

#### Scenario: Ein Fenster

- **WHEN** der Nutzer auf macOS ein Fenster teilen wählt
- **THEN** öffnet das System einen Dialog für Fenster

### Requirement: Teilen braucht auf macOS keine Quellenliste

In einem verbundenen Gespräch auf macOS MUST der Nutzer beide Teilen-Aktionen erreichen, ohne dass die App zuvor Bildschirme oder Fenster aufgezählt hat.

#### Scenario: Verbunden ohne vorausgefüllte Liste

- **WHEN** ein Gespräch verbunden ist und die Sitzung macOS ist
- **THEN** kann der Nutzer ganzen Bildschirm und ein Fenster wählen
- **AND** das Teilen-Steuerelement ist nicht deaktiviert, nur weil keine Quellenliste vorliegt

### Requirement: Bestätigtes macOS-Teilen bleibt in der App steuerbar

Nach Bestätigung einer Quelle im ScreenCaptureKit-Dialog MUST die App die lokale Freigabe anzeigen, und der Nutzer MUST sie beenden können, ohne das Gespräch zu verlassen.

#### Scenario: Banner und Stopp

- **WHEN** der Nutzer im ScreenCaptureKit-Dialog eine Quelle bestätigt
- **THEN** zeigt die App, dass lokal geteilt wird
- **AND** der Nutzer kann das Teilen beenden und das Gespräch läuft weiter

### Requirement: Abbruch des macOS-Dialogs lässt das Gespräch

Bricht der Nutzer den ScreenCaptureKit-Dialog ab, MUST keine Freigabe starten und MUST das Gespräch verbunden bleiben.

#### Scenario: Dialog abgebrochen

- **WHEN** der Nutzer den ScreenCaptureKit-Dialog abbricht
- **THEN** startet kein Teilen
- **AND** das Gespräch bleibt verbunden
- **AND** es erscheint keine Fehlermeldung

### Requirement: Fehlende macOS-Freigabe ist sichtbar

Kann die App den ScreenCaptureKit-Dialog nicht öffnen oder die Freigabe nicht starten, MUST sie das in einem verbundenen Gespräch klar anzeigen.

#### Scenario: Freigabe fehlt

- **WHEN** der Nutzer auf macOS Teilen startet und der System-Dialog nicht verfügbar ist
- **THEN** sieht der Nutzer einen klaren Hinweis
- **AND** der Knopf wirkt nicht lediglich wie «noch nicht verbunden»

## MODIFIED Requirements

### Requirement: Windows und reines X11 behalten die Liste

Auf Windows und in einer X11-Sitzung ohne Wayland MUST das Teilen-Menü Bildschirme und Fenster mit Vorschaubildern anbieten, und die Auswahl MUST das Teilen ohne Desktop-Portal-Dialog starten. Auf macOS MUST dieses Listen-Verhalten nicht gelten; dort gilt der ScreenCaptureKit-Dialog.

#### Scenario: Liste auf Windows

- **WHEN** der Nutzer auf Windows in einem verbundenen Gespräch Teilen öffnet
- **THEN** zeigt das Menü Bildschirme und Fenster mit Vorschaubildern
- **AND** die Auswahl einer Quelle startet das Teilen ohne Desktop-Portal-Dialog

#### Scenario: Reines X11

- **WHEN** die Sitzung X11 ist und `WAYLAND_DISPLAY` nicht gesetzt ist
- **THEN** zeigt das Menü Bildschirme und Fenster mit Vorschaubildern
- **AND** die Auswahl einer Quelle startet das Teilen ohne Desktop-Portal-Dialog

#### Scenario: macOS bleibt beim System-Dialog

- **WHEN** der Nutzer auf macOS in einem verbundenen Gespräch Teilen öffnet
- **THEN** zeigt das Menü keine Quellenliste mit Vorschaubildern
- **AND** die Teilen-Aktion öffnet den ScreenCaptureKit-Dialog
