# Design

## Context

See `proposal.md` for motivation. Automatic sign-in today is Linux-only: [`crates/app/src/main.rs`](crates/app/src/main.rs) calls [`linux_browser::start`](crates/app/src/linux_browser.rs) only under `target_os = "linux"`. macOS falls through to `CdpTransport` and port 9222. [`crates/browser`](crates/browser/src/config.rs) knows `Wsl | Windows | Linux`: Chrome search, `ss`/`/proc` kill, and user agent (outside Linux as Windows NT) do not cover macOS.

Audio and camera already use the non-Windows path: Auto/Low → ADM ([`MicSettings::uses_device_track_on`](crates/calling/src/mic_processing.rs), CoreAudio on macOS), Music/Off/computer sound → cpal, camera → nokhwa `input-native`. [`scripts/build-macos.sh`](scripts/build-macos.sh) sets usage strings in the `.app`.

Screen sharing: [`share_picker_for`](crates/calling/src/screen.rs) only knows `WAYLAND_DISPLAY`. With ScreenCaptureKit system picker active, `get_source_list` is empty; the same delegated picker API as Wayland portal (`start_capture(None)`, `has_delegated_picker`, `watch_picker`) already exists in libwebrtc.

## Goals / Non-Goals

**Goals:**

- Same Chrome supervision as Linux on macOS (start, login window, headless, watchdog, `--endpoint`).
- Share picker on macOS via ScreenCaptureKit dialog, without preview list.
- Pin existing audio and camera behaviour in specs and cover with unit tests where gaps exist.

**Non-Goals:**

- Built-in login without Chrome, WebView2 on macOS.
- New camera or ADM pipeline.
- Upstream PR; delivery on fork only.
- Remaining roadmap gaps (Linux notifications, light theme, …).

## Decisions

### `Platform::Macos` in the browser crate

New variant beside Linux/Windows/WSL in [`config.rs`](crates/browser/src/config.rs):

- Profile and mode file under Application Support (`directories` / `ProjectDirs`), name like Linux `rusty-teams-chrome`.
- Chrome search: fixed candidates `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`, Chromium counterpart, `~/Applications/…`, plus PATH names.
- User agent in [`launch.rs`](crates/browser/src/launch.rs): macOS Chrome string when `Platform::Macos`.
- Port kill in [`process.rs`](crates/browser/src/process.rs): listener via `lsof` (or equivalent), process name from `ps`/`comm`; `is_chrome_image` also accepts `Google Chrome`.

### Supervisor for non-Windows

Bring [`linux_browser.rs`](crates/app/src/linux_browser.rs) and `cfg(target_os = "linux")` sites in `main.rs` to macOS (rename module or `cfg(any(linux, macos))`). Behaviour unchanged: first start → login window, else `ensure_running`, `hide_after_login`, watchdog, live retry after headless.

### Share picker: macOS = delegated like Wayland

`share_picker_for` returns `SharePicker::Portal` on macOS (or a shared name for «delegated»), independent of `WAYLAND_DISPLAY`. Existing portal capture thread in `screen.rs` reuses `start_capture(None)` + `watch_picker` + `ensure_picker_visible`; ScreenCaptureKit is on by default in libwebrtc. Menu: two actions without source list, as on Wayland.

### Audio and camera: spec first, little code

`uses_device_track_on(false)` already holds for macOS. Spec and possibly a clearly named test («not Windows») document CoreAudio. Camera: no pipeline change; usage strings stay in `build-macos.sh`.

### Docs

README status line macOS: self-started Chrome like Linux. Fork remote for everyday pushes.

## Risks / Trade-offs

- [Chrome app bundle path differs / Chromium only] → candidate list + PATH; log error clearly and point to `--endpoint`.
- [ScreenCaptureKit dialog without TCC / usage string] → `.app` bundle required; bare binary shows no dialog.
- [Process name «Google Chrome» fails `starts_with("chrome")`] → extend kill filter explicitly and unit-test.
- [Live smoke only on Mac runner] → unit tests for config/launch/picker on Linux CI; manual smoke on `macos-arm64`.

## Migration Plan

No persisted state. Existing manual `--endpoint` users on macOS keep the anchor. Rollback is the commit. Delivery on `fork` only.
