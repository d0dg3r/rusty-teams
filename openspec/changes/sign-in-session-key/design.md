# Design

## Context

See proposal.md for why the hand-over loops. Today `hide_after_login` in `crates/app/src/linux_browser.rs` calls `Browser::headless`, which stops Chromium and starts a new process. `teams_has_msal_cache` in `crates/browser/src/browser.rs` treats localStorage key names containing `accesstoken` and `refreshtoken` as a finished sign-in. `fetch.js` can open sealed entries only while the `msal.cache.encryption` session cookie is present. Upstream pull request 123 already persists that one cookie; this fork does not have `msal_key.rs`. The app stop in `linux_browser.rs` allows 2 seconds, which is shorter than a 500 ms cookie save plus the existing close and profile-release waits.

## Goals / Non-Goals

**Goals:**

- Persist only the MSAL cache-encryption cookie before a Chromium stop, with the same conversion and tests as upstream pull request 123.
- Raise the app stop budget so that save cannot cancel the close.
- Finish sign-in only when the Teams page reports an opened sealed entry or a still-valid access token.

**Non-Goals:**

- Guest-organisation MFA, org restart, or a banner action back to the home organisation (upstream pull request 128).
- Changing `teams_has_msal_cache` for tab parking.
- Firefox-family cookie handling.
- Deleting the Chromium profile from the app. A one-time profile reset on this machine is a verification step, not product behaviour.

## Decisions

### Persist the cookie the way upstream already does

Copy `crates/browser/src/msal_key.rs` and call it from `close_gracefully` on the Chromium CDP path, bounded by `Timeouts.msal_key` (500 ms). A timeout or CDP error is logged and `close_over_cdp` still runs. Host-only cookies are rewritten with `url` so they stay host-only; domain cookies keep `domain`. Duplicates collapse with the host-only cookie winning.

Alternative considered: set the cookie from Rust after the new process starts. Rejected because MSAL reads the cookie as the page loads and drops sealed entries before a late set. The upstream order (expiry before stop, then launch) is the one a reporter already confirmed.

### Stop budget is the sum of the steps

`STOP_TIMEOUT` in `linux_browser.rs` becomes 6 seconds: 500 ms cookie budget, up to 3 seconds for the CDP close, 2 seconds profile release. A unit test asserts the timeout is at least that sum so a later timeout edit cannot drop the close again.

### The hide gate reads a page report, not key names

A new page expression, evaluated with `awaitPromise`, walks localStorage the way `fetch.js` does: sealed entries are those with `id`, `nonce`, and `data`; it opens them with the encryption cookie; a still-valid access token is an `AccessToken` whose `expiresOn` is still in the future. The hide tracker advances only when `opened > 0` or a still-valid access token is present. `teams_has_msal_cache` stays for parking.

Alternative considered: call `fetch.js` with an empty request. Rejected because that script acquires tokens and can refresh, which is the wrong side effect for a poll that runs twice a second.

## Risks / Trade-offs

- [The 500 ms budget expires on a slow page] → the close still happens, a warning is logged, and the next start asks for sign-in once. The stop timeout test keeps the close inside the app budget.
- [The encryption key is stored in the profile cookie store] → the profile already holds the session cookies that can renew tokens. Same trade-off upstream accepted. No other cookies are rewritten.
- [A Teams page that looks signed in but has only expired plain entries keeps the window up] → that is the intended stop for the loop. The user completes sign-in until a usable token exists.
- [The unseal snippet can drift from `fetch.js`] → the hide check only needs opened-or-fresh, not scope matching. The pure decision function is unit-tested without a browser.

## Migration Plan

Ship the binary, then on this machine quit the app and remove only `~/.local/share/rusty-teams-chrome` and `~/.local/share/rusty-teams-chrome.mode`. Leave `~/.local/share/ms-teams-linux`. Sign in once. Confirm the diagnostics log shows a sealed count above zero and an opened count above zero after the background hand-over, then two minutes online without `LoginRequired`, including one app restart.

Rollback is reverting the commit. A profile that already lost its sealed cache cannot be repaired by the old binary either.

## Open Questions

None.
