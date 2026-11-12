# Design

## Context

Siehe `proposal.md` für den Anlass. Automatisches Anmelden ist heute Linux-only: [`crates/app/src/main.rs`](crates/app/src/main.rs) ruft nur unter `target_os = "linux"` [`linux_browser::start`](crates/app/src/linux_browser.rs) auf. macOS fällt auf `CdpTransport` und Port 9222. [`crates/browser`](crates/browser/src/config.rs) kennt `Wsl | Windows | Linux`: Chrome-Suche, `ss`/`/proc`-Kill und User-Agent (ausserhalb Linux als Windows NT) decken macOS nicht ab.

Ton und Kamera laufen bereits über den Nicht-Windows-Pfad: Auto/Low → ADM ([`MicSettings::uses_device_track_on`](crates/calling/src/mic_processing.rs), auf macOS CoreAudio), Music/Off/Computer-Ton → cpal, Kamera → nokhwa `input-native`. [`scripts/build-macos.sh`](scripts/build-macos.sh) setzt die Usage-Strings im `.app`.

Bildschirmteilen: [`share_picker_for`](crates/calling/src/screen.rs) kennt nur `WAYLAND_DISPLAY`. Mit aktivem ScreenCaptureKit-System-Picker ist `get_source_list` leer; dieselbe delegated-Picker-API wie beim Wayland-Portal (`start_capture(None)`, `has_delegated_picker`, `watch_picker`) ist in libwebrtc schon vorhanden.

## Goals / Non-Goals

**Goals:**

- Dieselbe Chrome-Betreuung wie Linux auf macOS (Start, Login-Fenster, headless, Watchdog, `--endpoint`).
- Share-Picker auf macOS über den ScreenCaptureKit-Dialog, ohne Vorschauliste.
- Bestehendes Audio- und Kamera-Verhalten in Specs festhalten und mit Unit-Tests absichern, wo es Lücken gibt.

**Non-Goals:**

- Eingebautes Login ohne Chrome, WebView2 auf macOS.
- Neue Kamera- oder ADM-Pipeline.
- Upstream-PR; Lieferung nur auf dem Fork.
- Übrige Roadmap-Lücken (Linux-Benachrichtigungen, Light Theme, …).

## Decisions

### `Platform::Macos` im Browser-Crate

Neue Variante neben Linux/Windows/WSL in [`config.rs`](crates/browser/src/config.rs):

- Profil und Mode-Datei unter Application Support (`directories` / `ProjectDirs`), Name wie Linux `rusty-teams-chrome`.
- Chrome-Suche: feste Kandidaten `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`, Chromium-Pendant, `~/Applications/…`, plus PATH-Namen.
- User-Agent in [`launch.rs`](crates/browser/src/launch.rs): macOS-Chrome-String wenn `Platform::Macos`.
- Port-Kill in [`process.rs`](crates/browser/src/process.rs): Listener per `lsof` (oder gleichwertig), Prozessname aus `ps`/`comm`; `is_chrome_image` akzeptiert auch `Google Chrome`.

### Supervisor für Nicht-Windows

[`linux_browser.rs`](crates/app/src/linux_browser.rs) und die `cfg(target_os = "linux")`-Stellen in `main.rs` auf macOS mitnehmen (Modul umbenennen oder `cfg(any(linux, macos))`). Verhalten bleibt: Erststart → Login-Fenster, sonst `ensure_running`, `hide_after_login`, Watchdog, Live-Retry nach Headless.

### Share-Picker: macOS = delegated wie Wayland

`share_picker_for` liefert auf macOS `SharePicker::Portal` (oder ein gemeinsamer Name für «delegated»), unabhängig von `WAYLAND_DISPLAY`. Der bestehende Portal-Capture-Thread in `screen.rs` wiederverwendet `start_capture(None)` + `watch_picker` + `ensure_picker_visible`; ScreenCaptureKit ist in libwebrtc standardmässig an. Menü: zwei Aktionen ohne Quellenliste, wie unter Wayland.

### Audio und Kamera: Spec first, wenig Code

`uses_device_track_on(false)` gilt bereits für macOS. Spec und ggf. ein klar benannter Test («nicht Windows») dokumentieren CoreAudio. Kamera: keine Pipeline-Änderung; Usage-Strings bleiben in `build-macos.sh`.

### Doku

README-Statuszeile macOS: selbst gestartetes Chrome wie Linux. Fork-Remote für Alltagspushes.

## Risks / Trade-offs

- [Chrome-App-Bundle-Pfad weicht ab / nur Chromium] → Kandidatenliste + PATH; Fehler klar loggen und auf `--endpoint` hinweisen.
- [ScreenCaptureKit-Dialog ohne TCC / Usage-String] → `.app`-Bundle Pflicht; bare Binary zeigt keinen Dialog.
- [Prozessname «Google Chrome» scheitert an `starts_with("chrome")`] → Kill-Filter explizit erweitern und unit-testen.
- [Live-Smoke nur auf dem Mac-Runner] → Unit-Tests für Config/Launch/Picker auf Linux CI; manueller Smoke auf `macos-arm64`.

## Migration Plan

Kein gespeicherter Zustand. Bestehende manuelle `--endpoint`-Nutzer auf macOS behalten den Anker. Rückbau ist der Commit. Lieferung nur auf `fork`.
