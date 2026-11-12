# Proposal

## Why

Fenster- und Bildschirmteilen folgt heute dem Windows-Modell: die App zählt Quellen auf und zeigt sie mit Vorschaubildern. Unter Wayland darf eine App fremde Fenster nicht auflisten. Auf KDE, GNOME und Hyprland bleibt der Share-Knopf dadurch leer, tot oder hängt an einem Platzhalter, obwohl PipeWire und das ScreenCast-Portal auf dem Desktop schon bereitstehen.

## What Changes

- Unter Wayland (gesetztes `WAYLAND_DISPLAY`, auch wenn daneben ein XWayland-`DISPLAY` existiert) bietet das Teilen-Menü zwei Aktionen ohne Vorschaubilder: ganzen Bildschirm teilen, ein Fenster teilen.
- Jede Aktion öffnet den ScreenCast-Dialog des laufenden Desktops. KDE, GNOME und Hyprland zeichnen diesen Dialog selbst; die App stellt immer dieselbe Anfrage, gefiltert auf Monitore beziehungsweise Fenster.
- Nach der Auswahl laufen die Frames über die bestehende Teilen-Strecke (Banner, Stopp, Bühne).
- Abbruch des Dialogs lässt das Gespräch laufen, ohne Fehlermeldung.
- Fehlt ein ScreenCast-Portal, erscheint ein klarer Hinweis statt eines still toten Knopfes.
- Beim Teilen des ganzen Bildschirms weicht das eigene Fenster, damit es nicht in der Aufnahme bleibt.
- Windows und eine reine X11-Session behalten die bestehende Liste mit Vorschaubildern.

## Capabilities

### New Capabilities

- `screen-share`: Quelle für lokales Bildschirm- und Fensterteilen in einem Gespräch wählen, inklusive Wayland-Portal und der bestehenden Liste auf Windows und reinem X11.

### Modified Capabilities

- Keine. `linux-call-audio` (Computer-Ton) bleibt unverändert.

## Impact

- Teilen-Menü und der Start der lokalen Aufnahme in einem laufenden Gespräch.
- Laufzeit unter Wayland: ScreenCast-Portal des Desktops (KDE, GNOME, Hyprland), PipeWire, ein GLib-Main-Loop vor dem Portal-Aufruf. Die Libwebrtc-Build enthält PipeWire bereits.
- Kein Compositor-Sonderweg (`hyprctl` und vergleichbare private Listen).
- Empfang einer fremden Freigabe, H.264-Bühne, Computer-Ton, Restore-Token und Vorschaubilder im eigenen Menü unter Wayland bleiben ausserhalb dieses Changes.
- Lieferung auf dem Fork. Kein Upstream-PR der ganzen Fork-Linie.
