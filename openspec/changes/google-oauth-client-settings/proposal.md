# Proposal

## Why

Google Calendar Connect depends on a client id and secret that are compiled into the binary or exported in the shell. A person who wants their own Google Cloud Desktop client has to rebuild. Settings should accept that pair, with a short guide, without taking away the one-click path when the fields stay empty.

## What Changes

- Settings › Calendar accounts gains fields for a Google OAuth client id and client secret, plus a short guide for creating a Desktop client.
- A saved pair (both non-empty) is used for Connect and token refresh instead of the process environment and the compiled client.
- An empty pair leaves the existing order: runtime environment, then the compiled client. Official builds still connect without the user pasting credentials.
- The client id is stored in app metadata. The secret is stored in the OS keyring, never in the calendar account JSON, logs, or the secret field after save.
- Saving a pair while a Google account is already connected tells the user to disconnect and connect again, because existing tokens belong to the previous client.

## Capabilities

### New Capabilities

- None.

### Modified Capabilities

- `calendar-accounts`: a user-supplied Desktop client in Settings overrides the environment and the compiled client when both id and secret are saved. Empty settings keep the one-click release path.

## Impact

- Calendar account settings, Google connect, and Google token refresh.
- OS keyring (same pattern as CalDAV passwords).
- README and a new decision record. Release builds and the local Linux install script stay as they are.
