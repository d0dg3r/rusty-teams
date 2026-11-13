# Tasks

## 1. Browser platform macOS

- [x] 1.1 `Platform::Macos` in `crates/browser/src/config.rs` with profile under Application Support and Chrome candidates under `/Applications`, `~/Applications`, and PATH. Check with `cargo test -p browser --lib`.
- [x] 1.2 Set user agent in `crates/browser/src/launch.rs` for macOS as macOS Chrome (not Windows NT). Check with `cargo test -p browser --lib user_agent`.
- [x] 1.3 Port listener and kill in `crates/browser/src/process.rs` for macOS (`lsof`/`ps`); `is_chrome_image` accepts `Google Chrome`. Check with `cargo test -p browser --lib`.

## 2. Managed Chrome on macOS

- [x] 2.1 Bring supervisor from `crates/app/src/linux_browser.rs` and `cfg` sites in `crates/app/src/main.rs` to macOS (start, login window, headless after MSAL, watchdog, stop). Check with `cargo check -p app` (macOS target or `cfg` tests where possible).
- [x] 2.2 README status line macOS: self-started Chrome like Linux, `--endpoint` optional. Check paragraph mentions login and debug port.

## 3. ScreenCaptureKit share

- [x] 3.1 `share_picker_for` / `current_share_picker` in `crates/calling/src/screen.rs` pick delegated picker on macOS (like Wayland portal). Check with `cargo test -p calling --lib portal_mode`.
- [x] 3.2 Use existing portal capture path for macOS: dialog without source list, silent cancel, error as Notice. Check with `cargo test -p calling --lib portal_share`.
- [x] 3.3 Call UI/`can_share`: on macOS allow share on connected call even without source list. Check with `cargo test -p app-call-model --lib` (share/portal filter).

## 4. Secure audio and camera

- [x] 4.1 Ensure Auto/Low on non-Windows keep ADM device track and Music/Off/computer sound use software chain; test names/comments make CoreAudio on macOS clear. Check with `cargo test -p calling --lib mic_processing`.
- [x] 4.2 Keep usage strings in `scripts/build-macos.sh` for microphone, camera, and screen capture or verify against spec. Check all three keys are in the script.

## 5. Integration

- [x] 5.1 `cargo test -p browser --lib` and `cargo test -p calling --lib` green together.
- [x] 5.2 On a Mac (runner or local): app without `--endpoint` starts Chrome, login window appears when needed and goes back; share opens system dialog. Without Mac session do not fail the task.

## Workflow follow-up

- After `/opsx-apply` and review archive the change (`/opsx-archive`) so `macos-sign-in`, `macos-call-audio`, and the `screen-share` delta land under `openspec/specs/`.
