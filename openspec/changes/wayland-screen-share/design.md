# Design

## Context

Siehe `proposal.md` für den Anlass. Heute zählt `crates/calling/src/screen.rs` Bildschirme und Fenster über `GetSourceList` und baut daraus das Menü in `crates/app/src/views/call_view.rs`. `can_share()` in `crates/app-call-model/src/model.rs` ist nur wahr, wenn diese Liste nicht leer ist. Vorschaubilder rufen `capture_frame` auf, bevor der Nutzer etwas gewählt hat.

Die mitgelieferte Libwebrtc ist mit `WEBRTC_USE_PIPEWIRE` gebaut. `vendor/webrtc-sys/src/desktop_capturer.cpp` setzt `allow_pipewire`. `BaseCapturerPipeWire` implementiert `GetDelegatedSourceListController`, `EnsureVisible` und `Observe`. Die cxx-Bindung in `vendor/webrtc-sys` reicht diesen Controller nicht durch. Der GLib-Loop startet in `vendor/libwebrtc/src/native/desktop_capturer.rs` erst in `start()`, und nur wenn `WAYLAND_DISPLAY` gesetzt ist.

Unter Wayland ist `GetSourceList` eine delegierte Liste: höchstens ein Platzhalter, brauchbar erst nach der Auswahl im Desktop-Dialog.

## Goals / Non-Goals

**Goals:**

- Ein Portal-Pfad für KDE, GNOME und Hyprland, ausgelöst von zwei Menüaktionen.
- Windows und reines X11 behalten Liste und Vorschaubilder.
- Abbruch, fehlendes Portal und das Weichen des Hauptfensters beim ganzen Bildschirm sind im bestehenden Call-Ablauf angeschlossen.

**Non-Goals:**

- Restore-Token, Vorschaubilder unter Wayland, Regionswahl, Computer-Ton (`linux-call-audio`, `parec`).
- Compositor-private Listen.
- Upstream-PR. Die Bindungsänderung bleibt auf dem Fork.

## Decisions

### Sitzung über `WAYLAND_DISPLAY`

Portal-Pfad genau dann, wenn `WAYLAND_DISPLAY` gesetzt ist, auch neben `DISPLAY` für XWayland. Dieselbe Bedingung nutzt Libwebrtc für den PipeWire-Capturer. `XDG_SESSION_TYPE` allein würde vom Capturer abweichen.

Die Call-Task meldet den Modus einmal als Update (Portal oder Liste). Das Modell speichert ihn. `can_share()` ist im Portal-Modus wahr, sobald das Gespräch verbunden ist, auch bei leerer `share_sources`.

### Zwei Aktionen, zwei Capturer-Arten

«Ganzen Bildschirm» erzeugt einen Screen-Capturer, «Ein Fenster» einen Window-Capturer. WebRTC mappt das auf die Portal-Typen Monitor und Fenster. `CreateGenericCapturer` würde beide Arten in einem Dialog mischen und die zwei Aktionen aufheben.

`StartShare(ShareSource)` bleibt für die Listen-Auswahl. Für den Portal-Weg kommt ein eigener Befehl mit der Art (Bildschirm oder Fenster), ohne vorherige Quellen-Id. Kein Platzhalter-Eintrag in `share_sources`, sonst lösen Vorschaubilder in `crates/calling/src/call.rs` den Dialog beim Öffnen des Menüs aus.

### Dialog über den delegierten Controller

Ablauf nach dem Klick:

```
GLib-Default-Context läuft
        |
        v
Capturer Start(callback)     ohne SelectSource
        |
        v
Observe + EnsureVisible
        |
        +-- Auswahl --> GetSourceList, SelectSource, bisherige Frame-Schleife
        +-- Abbruch --> Capturer weg, kein Notice
        +-- Fehler  --> CallUpdate::Notice, kein Teilen
```

`EnsureVisible` ist Pflicht: `BaseCapturerPipeWire` hängt den Portal-Dialog daran. Die Bindung in `vendor/webrtc-sys/include/livekit/desktop_capturer.h` und `vendor/libwebrtc` bekommt Observe, EnsureVisible und die drei Rückrufe. Dünn halten, damit ein Libwebrtc-Bump überschaubar bleibt.

Der GLib-Loop ist einer für den Prozess, auf dem Default-Context, gestartet bevor `Start` oder `EnsureVisible` läuft, und am Leben solange ein Portal-Teilen möglich ist. Pro Capturer einen Loop zu starten und beim Drop zu beenden reisst die Portal-Session ab. Rückrufe des Controllers laufen auf dem Loop-Thread und wechseln auf den bestehenden Capture-Besitzer, bevor die Frame-Schleife blockiert. Der Loop selbst wird nicht gejoint.

### Hauptfenster beim ganzen Bildschirm

`SetExcludedWindow` und `sync_capture_exclusion` in `crates/app/src/call/overlay.rs` wirken auf PipeWire nicht: der Compositor liefert das fertige Bild. `minimize_for_share` minimiert nur, wenn `minimize_on_share_start` in `crates/app-state/src/call/share_overlay.rs` Überlappung sieht. Globale Rechtecke gibt Wayland nicht her.

Beim Portal-Bildschirm gilt Minimieren immer, unabhängig von Rechtecken. Fenster-Teilen minimiert nicht; das gewählte Fenster ist die Aufnahme.

### Hinweis, wenn das Portal fehlt

Schlägt das Erzeugen des Capturers oder `EnsureVisible` fehl, geht der Text über `CallUpdate::Notice`. Der bestehende Tooltip «Sharing starts once the call is connected» bleibt dem unverbundenen Gespräch vorbehalten.

## Risks / Trade-offs

- [Portal ignoriert den Typ-Filter und zeigt Monitore und Fenster zusammen] → Anfrage bleibt Screen- oder Window-Capturer. Prüfen auf diesem Hyprland. Keine zweite Liste in der App bauen.
- [Frames bleiben schwarz, DMA-BUF kommt nicht als CPU-Bild an] → Manuell auf Hyprland gegenprüfen. Die bestehende Umwandlung nach I420 in `screen.rs` erwartet befüllte Frame-Bytes. Leere Frames werden nicht als erfolgreiches Teilen gemeldet.
- [Portal-Aufruf vom falschen Thread] → Loop zuerst, Default-Context, `Start` und `EnsureVisible` erst danach.
- [Mehrere Portal-Implementierungen installiert] → Die App wählt die Implementierung nicht. Das Desktop routet ScreenCast (hier `hyprland-portals.conf` mit `default=hyprland;gtk`).
- [Bindung bricht beim nächsten Libwebrtc-Bump] → Nur Controller-Rückrufe ergänzen, keine Kopie der Portal-Logik.

## Migration Plan

Kein gespeicherter Zustand. Rückbau ist der Commit. Laufzeit vorausgesetzt: PipeWire und ein ScreenCast-Portal des Desktops. `README.md` erwähnt bei Linux-Teilen das Portal in einem Satz. Lieferung nur auf `fork`.
