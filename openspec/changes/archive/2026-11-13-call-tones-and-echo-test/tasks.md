# Tasks

## 1. OpenSpec artifacts

- [x] 1.1 Write proposal, design, `call-tones` and `echo-test-call` deltas, and this task list. Verify with `openspec validate call-tones-and-echo-test --type change`.

## 2. Linux tones from upstream

- [x] 2.1 Merge `upstream/main` into the fork branch and resolve conflicts so `linux_sound.rs`, the Linux `rodio` dependency, and stub re-exports land. Verify with `test -f crates/app-base/src/notify/platform/linux_sound.rs` and `rg 'cfg\\(target_os = "linux"\\)' crates/app-base/Cargo.toml`.
- [x] 2.2 Confirm Linux builds the sound path. Verify with `cargo check -p app-base`.

## 3. macOS tones

- [x] 3.1 Gate `linux_sound` for `any(target_os = "linux", target_os = "macos")` in `platform/mod.rs` / `stub.rs` and add the macOS `rodio` dependency. Verify with `rg 'macos' crates/app-base/src/notify/platform/mod.rs crates/app-base/Cargo.toml`.
- [x] 3.2 Check the crate still compiles for the host. Verify with `cargo check -p app-base`.

## 4. Echo diagnose and fail-fast

- [x] 4.1 When `add_echo_bot` fails, record status plus body excerpt on the call timeline / report. Verify with a unit test or by inspecting the timeline helper that formats the signaling error.
- [x] 4.2 Deliver the add result into the call loop (channel or await) and end the Echo call with a notice on failure instead of waiting on the callee gate. Verify with `cargo test -p calling --lib`.
- [x] 4.3 After recording the failure reason from a live or captured 400, fix the add request (create Echo 1:1 chat thread when the probe misses and pass it as `groupChat`, if that is the cause). Verify with `cargo test -p calling --lib` covering the add body / thread id.

## 5. Integration verify

- [x] 5.1 Run `cargo test -p calling --lib` and `cargo test -p app-state --lib` green.
- [x] 5.2 Manual: on Linux, start an Echo test call — tones audible when applicable, call either connects or ends with a notice (not stuck connecting). Without a live session, do not fail the task.

## Workflow follow-up

- After apply and review, archive the change so `call-tones` and `echo-test-call` land under `openspec/specs/`.
- Optional thin upstream PRs: macOS tones slice; Echo fail-fast / thread slice — each from fresh `upstream/main`.
