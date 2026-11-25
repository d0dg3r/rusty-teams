# Tasks

## 1. Wayland idle module

- [x] 1.1 Add Linux deps `wayland-client` 0.31 and `wayland-protocols` 0.32 (`client`, `staging`) to `crates/app-base/Cargo.toml` and verify `x11rb` stays `shape` only
- [x] 1.2 Add `crates/app-base/src/linux_idle.rs` with the Wayland `ext-idle-notify-v1` watcher (version 2 input-only when offered, else version 1), a module credit to Lukas Grundtner and pull request 96, and a unit test for the idle duration helper
- [x] 1.3 Point Linux `system_idle()` in `crates/app-base/src/user_activity.rs` at that module and leave other non-Windows targets returning `None`

## 2. Verify and credit

- [x] 2.1 Run `cargo test -p app-base --lib user_activity linux_idle` and confirm both modules pass
- [x] 2.2 Add a changelog bullet that names Lukas Grundtner and links pull request 96, and confirm no upstream pull request was opened
