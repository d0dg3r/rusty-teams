# screen-share Specification

## Purpose

Lokales Teilen von Bildschirm oder Fenster in einem Gespräch: unter Wayland und auf macOS über den System-Dialog, auf Windows und reinem X11 über die Liste in der App.

## Requirements

### Requirement: Wayland öffnet den Desktop-Dialog

In einem verbundenen Gespräch unter Wayland MUST die App den ScreenCast-Dialog des Desktops öffnen. Sie MUST Quellen dort nicht selbst mit Vorschaubildern auflisten.

#### Scenario: Ganzer Bildschirm

- **WHEN** der Nutzer unter Wayland den ganzen Bildschirm teilen wählt
- **THEN** öffnet das Desktop einen Dialog nur für Monitore
- **AND** die App zeigt keine eigene Quellenliste mit Vorschaubildern

#### Scenario: Ein Fenster

- **WHEN** der Nutzer unter Wayland ein Fenster teilen wählt
- **THEN** öffnet das Desktop einen Dialog nur für Fenster

#### Scenario: XWayland daneben

- **WHEN** `WAYLAND_DISPLAY` gesetzt ist und zusätzlich ein X11-`DISPLAY` existiert
- **THEN** öffnet Teilen denselben Desktop-Dialog wie ohne dieses `DISPLAY`

#### Scenario: KDE, GNOME und Hyprland

- **WHEN** der Nutzer auf KDE, GNOME oder Hyprland dieselbe Teilen-Art wählt
- **THEN** erscheint der Dialog dieses Desktops für Monitore beziehungsweise Fenster
- **AND** die App zeigt auf keinem der drei Desktops eine eigene Fensterliste

### Requirement: Teilen braucht unter Wayland keine Quellenliste

In einem verbundenen Gespräch unter Wayland MUST der Nutzer beide Teilen-Aktionen erreichen, ohne dass die App zuvor Bildschirme oder Fenster aufgezählt hat.

#### Scenario: Verbunden ohne vorausgefüllte Liste

- **WHEN** ein Gespräch verbunden ist und die Sitzung Wayland ist
- **THEN** kann der Nutzer ganzen Bildschirm und ein Fenster wählen
- **AND** das Teilen-Steuerelement ist nicht deaktiviert, nur weil keine Quellenliste vorliegt

### Requirement: Bestehende Teilen-Optionen bleiben

Das Teilen-Menü unter Wayland MUST die bestehenden Optionen für Computer-Ton, Bewegungsoptimierung und die eigene Person über dem Inhalt weiter anbieten.

#### Scenario: Menü vor dem Dialog

- **WHEN** der Nutzer unter Wayland das Teilen-Menü öffnet
- **THEN** sind «Include computer sound», «Optimize for motion» und «Show me over my content» erreichbar
- **AND** daneben stehen die zwei Aktionen für Bildschirm und Fenster

### Requirement: Bestätigtes Teilen bleibt in der App steuerbar

Nach Bestätigung einer Quelle im Desktop-Dialog MUST die App die lokale Freigabe anzeigen, und der Nutzer MUST sie beenden können, ohne das Gespräch zu verlassen.

#### Scenario: Banner und Stopp

- **WHEN** der Nutzer im Desktop-Dialog eine Quelle bestätigt
- **THEN** zeigt die App, dass lokal geteilt wird
- **AND** der Nutzer kann das Teilen beenden und das Gespräch läuft weiter

### Requirement: Abbruch lässt das Gespräch

Bricht der Nutzer den Desktop-Dialog ab, MUST keine Freigabe starten und MUST das Gespräch verbunden bleiben.

#### Scenario: Dialog abgebrochen

- **WHEN** der Nutzer den Desktop-Dialog abbricht
- **THEN** startet kein Teilen
- **AND** das Gespräch bleibt verbunden
- **AND** es erscheint keine Fehlermeldung

### Requirement: Fehlendes Portal ist sichtbar

Kann die App den ScreenCast-Dialog nicht öffnen, MUST sie das in einem verbundenen Gespräch klar anzeigen.

#### Scenario: Portal fehlt

- **WHEN** der Nutzer unter Wayland Teilen startet und kein ScreenCast-Portal erreichbar ist
- **THEN** sieht der Nutzer einen klaren Hinweis
- **AND** der Knopf wirkt nicht lediglich wie «noch nicht verbunden»

### Requirement: Ganzer Bildschirm ohne eigenes Fenster

Teilt der Nutzer den ganzen Bildschirm, MUST das Hauptfenster der App nicht im geteilten Bild bleiben.

#### Scenario: Hauptfenster weicht

- **WHEN** der Nutzer den ganzen Bildschirm teilt und der Desktop-Dialog bestätigt ist
- **THEN** ist das Hauptfenster der App nicht Teil des geteilten Bildes

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

### Requirement: Screen share start and stop reliability
Starting screen share SHALL deliver a picture on Windows, and stopping share SHALL complete without hanging the call UI.

#### Scenario: Windows share shows a picture
- **WHEN** the user starts screen share on Windows in a connected call
- **THEN** the remote side receives a share picture

#### Scenario: Stop never hangs
- **WHEN** the user stops screen share
- **THEN** the stop completes and the call UI remains responsive

### Requirement: Call windows remain screenshot-visible
Call, mini and gallery windows SHALL remain visible to the OS screenshot/capture path after share or overlay changes that previously hid them.

#### Scenario: Screenshot includes call windows
- **WHEN** the user captures the screen while a call window is open
- **THEN** the call window content is included in the capture where the OS allows it

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
