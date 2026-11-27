# Tasks

## 1. Encrypted-cache cookie

- [x] 1.1 Add `crates/browser/src/msal_key.rs` from upstream pull request 123, wire it into the Chromium close path with a 500 ms budget, and add `msal_key` to `Timeouts` including the test harness. Verify with `cargo test -p browser --lib msal_key`.
- [x] 1.2 Raise the app stop timeout in `crates/app/src/linux_browser.rs` so it covers the cookie budget, the CDP close, and profile release, with a unit test. Verify with `cargo test -p app --lib linux_browser`.

## 2. Finish sign-in only on a usable token

- [x] 2.1 Add a page report and a pure decision that is true only when a sealed entry opened or a still-valid access token exists. Verify with `cargo test -p browser --lib sign_in_ready`.
- [x] 2.2 Use that decision in `hide_after_login` instead of the localStorage name check. Verify with `cargo test -p app --lib linux_browser` covering the case where token-shaped names do not hide the window.

## 3. Proof on this machine

- [x] 3.1 Build and install the local binary. Quit the app, remove only the Chromium profile and mode file, start the app, and sign in once. Verify the cache-encryption cookie is persistent, the page reports a still-valid access token or an opened sealed entry after the background hand-over, and a restart stays online for two minutes without `LoginRequired`.
