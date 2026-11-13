# Tasks

## 1. Portal controller

- [x] 1.1 Pass `Observe`, `EnsureVisible`, and selection/cancel/error callbacks from `BaseCapturerPipeWire` through `vendor/webrtc-sys` and `vendor/libwebrtc`. Check with `cargo check -p libwebrtc --features glib-main-loop`.
- [x] 1.2 Start one GLib loop on the default context for the process before a portal capturer calls `Start` or `EnsureVisible`. Per-capturer loop in `vendor/libwebrtc/src/native/desktop_capturer.rs` must not stop this loop. Check with `cargo test -p calling --lib portal_loop`.

## 2. List or portal mode

- [x] 2.1 Report portal mode to call model exactly when `WAYLAND_DISPLAY` is set, else list mode. Check with `cargo test -p calling --lib portal_mode`.
- [x] 2.2 Make `can_share()` true in portal mode on connected call even with empty source list. Check with `cargo test -p app-call-model --lib portal_share`.
- [x] 2.3 In portal mode do not build `GetSourceList` entries or menu thumbnails. Check with `cargo test -p calling --lib portal_mode`.

## 3. Dialog, menu, notice

- [x] 3.1 Command for screen or window: screen vs window capturer, `EnsureVisible` without prior `SelectSource`, after selection existing frame loop. Cancel without `CallUpdate::Notice`, error with Notice. Check with `cargo test -p calling --lib portal_share`.
- [x] 3.2 Share menu in portal mode: two actions without thumbnails, plus «Include computer sound», «Optimize for motion», and «Show me over my content». List mode unchanged. Check with `cargo test -p app-call-model --lib share_menu`.
- [x] 3.3 Add one sentence in `README.md` for Linux share that Wayland needs the desktop ScreenCast dialog. Check sentence names portal and the three desktops.

## 4. Own window

- [x] 4.1 On portal entire screen always minimize main window without overlap from global rects. Window share does not minimize. Check with `cargo test -p app-state --lib portal_minimize`.

## 5. Integration

- [x] 5.1 `cargo test -p calling --lib portal` and `cargo test -p app-call-model --lib portal_share` and `cargo test -p app-state --lib portal_minimize` green together.
- [x] 5.2 On Hyprland in a connected call: screen dialog monitors only, window dialog windows only, cancel without notice, confirmed screen does not show main window in capture. KDE and GNOME use same path; without session there do not fail the task.

## Workflow follow-up

- After `/opsx-apply` and review, archive the change (`/opsx-archive`) so `screen-share` lands under `openspec/specs/`.
