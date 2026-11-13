# Tasks

## 1. Browser-Plattform macOS

- [x] 1.1 `Platform::Macos` in `crates/browser/src/config.rs` mit Profil unter Application Support und Chrome-Kandidaten unter `/Applications`, `~/Applications` sowie PATH. Prüfen mit `cargo test -p browser --lib`.
- [x] 1.2 User-Agent in `crates/browser/src/launch.rs` für macOS als macOS-Chrome setzen (nicht Windows NT). Prüfen mit `cargo test -p browser --lib user_agent`.
- [x] 1.3 Port-Listener und Kill in `crates/browser/src/process.rs` für macOS (`lsof`/`ps`); `is_chrome_image` akzeptiert `Google Chrome`. Prüfen mit `cargo test -p browser --lib`.

## 2. Managed Chrome auf macOS

- [x] 2.1 Supervisor aus `crates/app/src/linux_browser.rs` und die `cfg`-Stellen in `crates/app/src/main.rs` für macOS mitnehmen (Start, Login-Fenster, Headless nach MSAL, Watchdog, Stop). Prüfen mit `cargo check -p app` (macOS-Target oder `cfg`-Tests wo möglich).
- [x] 2.2 README-Statuszeile macOS: selbst gestartetes Chrome wie Linux, `--endpoint` optional. Prüfen, dass der Absatz Login und Debug-Port nennt.

## 3. ScreenCaptureKit-Teilen

- [x] 3.1 `share_picker_for` / `current_share_picker` in `crates/calling/src/screen.rs` auf macOS den delegated Picker wählen (wie Wayland-Portal). Prüfen mit `cargo test -p calling --lib portal_mode`.
- [x] 3.2 Bestehenden Portal-Capture-Pfad für macOS nutzen: Dialog ohne Quellenliste, Abbruch still, Fehler als Notice. Prüfen mit `cargo test -p calling --lib portal_share`.
- [x] 3.3 Call-UI/`can_share`: auf macOS Teilen bei verbundenem Gespräch auch ohne Quellenliste erlauben. Prüfen mit `cargo test -p app-call-model --lib` (Share-/Portal-Filter).

## 4. Audio und Kamera absichern

- [x] 4.1 Sicherstellen, dass Auto/Low auf Nicht-Windows den ADM-Gerätetrack behalten und Music/Off/Computer-Ton die Software-Kette; Testnamen/Kommentare CoreAudio für macOS klar machen. Prüfen mit `cargo test -p calling --lib mic_processing`.
- [x] 4.2 In `scripts/build-macos.sh` die Usage-Strings für Mikrofon, Kamera und Screen Capture belassen bzw. gegen die Spec prüfen. Prüfen, dass die drei Keys im Skript stehen.

## 5. Zusammenspiel

- [x] 5.1 `cargo test -p browser --lib` und `cargo test -p calling --lib` gemeinsam grün.
- [x] 5.2 Auf einem Mac (Runner oder lokal): App ohne `--endpoint` startet Chrome, Login-Fenster erscheint bei Bedarf und geht zurück; Teilen öffnet den System-Dialog. Ohne Mac-Sitzung den Task nicht als Fehlschlag werten.

## Workflow follow-up

- Nach dem Umsetzen mit `/opsx-apply` und Review den Change archivieren (`/opsx-archive`), damit `macos-sign-in`, `macos-call-audio` und das `screen-share`-Delta unter `openspec/specs/` landen.
