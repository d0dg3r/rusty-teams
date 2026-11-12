# Tasks

## 1. Portal-Controller

- [x] 1.1 `Observe`, `EnsureVisible` und die Rückrufe Auswahl, Abbruch und Fehler von `BaseCapturerPipeWire` durch `vendor/webrtc-sys` und `vendor/libwebrtc` reichen. Prüfen mit `cargo check -p libwebrtc --features glib-main-loop`.
- [x] 1.2 Einen GLib-Loop auf dem Default-Context für den Prozess starten, bevor ein Portal-Capturer `Start` oder `EnsureVisible` ruft. Der Per-Capturer-Loop in `vendor/libwebrtc/src/native/desktop_capturer.rs` darf diesen Loop nicht beenden. Prüfen mit `cargo test -p calling --lib portal_loop`.

## 2. Modus Liste oder Portal

- [x] 2.1 Portal-Modus genau bei gesetztem `WAYLAND_DISPLAY` an das Call-Modell melden, sonst den Listen-Modus. Prüfen mit `cargo test -p calling --lib portal_mode`.
- [x] 2.2 `can_share()` im Portal-Modus bei verbundenem Gespräch auch mit leerer Quellenliste wahr machen. Prüfen mit `cargo test -p app-call-model --lib portal_share`.
- [x] 2.3 Im Portal-Modus keine `GetSourceList`-Einträge und keine Vorschaubilder fürs Menü erzeugen. Prüfen mit `cargo test -p calling --lib portal_mode`.

## 3. Dialog, Menü, Hinweis

- [x] 3.1 Befehl für Bildschirm oder Fenster: Screen- beziehungsweise Window-Capturer, `EnsureVisible` ohne vorheriges `SelectSource`, nach Auswahl die bestehende Frame-Schleife. Abbruch ohne `CallUpdate::Notice`, Fehler mit Notice. Prüfen mit `cargo test -p calling --lib portal_share`.
- [x] 3.2 Teilen-Menü im Portal-Modus: zwei Aktionen ohne Vorschaubilder, plus «Include computer sound», «Optimize for motion» und «Show me over my content». Listen-Modus unverändert. Prüfen mit `cargo test -p app-call-model --lib share_menu`.
- [x] 3.3 In `README.md` bei Linux-Teilen einen Satz ergänzen, dass Wayland den ScreenCast-Dialog des Desktops braucht. Prüfen, dass der Satz Portal und die drei Desktops nennt.

## 4. Eigenes Fenster

- [x] 4.1 Beim Portal-Bildschirm das Hauptfenster immer minimieren, ohne Überlappung aus globalen Rechtecken. Fenster-Teilen minimiert nicht. Prüfen mit `cargo test -p app-state --lib portal_minimize`.

## 5. Zusammenspiel

- [x] 5.1 `cargo test -p calling --lib portal` und `cargo test -p app-call-model --lib portal_share` und `cargo test -p app-state --lib portal_minimize` gemeinsam grün.
- [ ] 5.2 Auf Hyprland in einem verbundenen Gespräch: Bildschirm-Dialog nur für Monitore, Fenster-Dialog nur für Fenster, Abbruch ohne Hinweis, bestätigter Bildschirm zeigt das Hauptfenster nicht in der Aufnahme. KDE und GNOME laufen über denselben Pfad; ohne Sitzung dort den Task nicht als Fehlschlag werten.

## Workflow follow-up

- Nach dem Umsetzen mit `/opsx-apply` und Review den Change archivieren (`/opsx-archive`), damit `screen-share` unter `openspec/specs/` landet.
