# Proposal

## Why

On Linux and macOS the app restarts the Teams session browser to move it into the background after sign-in. That restart drops the session cookie that holds the key for the encrypted token cache, so the next start cannot read the cache, the web app throws the cache away, and the user is asked to sign in again within seconds. The same restart is treated as a finished sign-in when local storage merely contains token-shaped names, which starts the loop even when no usable token exists.

## What Changes

- Before the managed Chromium process stops, the cache-encryption cookie is given an expiry so the next start can still open the encrypted token cache. Other session cookies stay as they are.
- The app moves the browser to the background only after the Teams page reports a still-valid access token, whether stored in the clear or decrypted from an encrypted cache entry. Token-shaped storage names and expired encrypted entries do not finish sign-in.
- The app-stop budget covers saving that cookie and then closing the browser. A save that does not finish in time is logged and the close still runs.
- Guest-organisation MFA, the org switcher, and the connection-banner way back to a home organisation stay unchanged.

## Capabilities

### New Capabilities

- None.

### Modified Capabilities

- `linux-sign-in`: background hand-over keeps the encrypted token cache readable, and sign-in is finished only when a token can actually be used.
- `macos-sign-in`: the same hand-over and finish rule, because macOS uses the same managed-browser restart.

## Impact

- Managed Chromium on Linux and macOS (headless hand-over, login window, hung restart, app exit).
- Sign-in splash phase "finishing" happens only after a usable token, so a dead cache leaves the window open.
- Firefox-family session browsers are unchanged: they do not use this Chromium cookie path.
- No UI chrome, colour, or layout change.
