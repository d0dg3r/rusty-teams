# screen-share Specification

## Purpose

Lokales Teilen von Bildschirm oder Fenster in einem Gespräch: unter Wayland über den Dialog des Desktops, auf Windows und reinem X11 über die Liste in der App.

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

Auf Windows und in einer X11-Sitzung ohne Wayland MUST das Teilen-Menü Bildschirme und Fenster mit Vorschaubildern anbieten, und die Auswahl MUST das Teilen ohne Desktop-Portal-Dialog starten.

#### Scenario: Liste auf Windows

- **WHEN** der Nutzer auf Windows in einem verbundenen Gespräch Teilen öffnet
- **THEN** zeigt das Menü Bildschirme und Fenster mit Vorschaubildern
- **AND** die Auswahl einer Quelle startet das Teilen ohne Desktop-Portal-Dialog

#### Scenario: Reines X11

- **WHEN** die Sitzung X11 ist und `WAYLAND_DISPLAY` nicht gesetzt ist
- **THEN** zeigt das Menü Bildschirme und Fenster mit Vorschaubildern
- **AND** die Auswahl einer Quelle startet das Teilen ohne Desktop-Portal-Dialog
