## 1. Resolve and store

- [x] 1.1 Extend `resolve_oauth` so a stored id and secret win only as a pair, and add tests for that order.
- [x] 1.2 Store the client id in store meta and the secret in the OS keyring. Empty id clears both. An empty secret field keeps an existing secret.
- [x] 1.3 Connect and Google sync use the resolved client, loading the keyring off the UI thread.

## 2. Settings

- [x] 2.1 Add client id, masked secret, save, reset, status, and the Desktop-client guide on calendar accounts (English and German).
- [x] 2.2 Include the new labels in settings search and the form source in the search test.

## 3. Docs

- [x] 3.1 Add ADR 0025 and a pointer from ADR 0009. Update the README Google Calendar section.

## 4. Verify

- [x] 4.1 `cargo test -p chatsvc google_calendar`
- [x] 4.2 `cargo test -p app settings::nav`
- [x] 4.3 `openspec validate google-oauth-client-settings`
