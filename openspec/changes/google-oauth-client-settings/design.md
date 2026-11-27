## Context

`client_id_from_env` in `crates/chatsvc/src/google_calendar/oauth.rs` prefers `TEAMS_GOOGLE_CLIENT_ID` / `TEAMS_GOOGLE_CLIENT_SECRET` at runtime and otherwise uses values compiled with `option_env!`. Connect and refresh call that helper from `crates/app-state`. Calendar account settings already host CalDAV credentials: the password goes to the OS keyring (`crates/app-state/src/caldav_credentials.rs`), not into the calendar JSON. ADR 0009 keeps the compiled Desktop client so a Dock or Start Menu launch can connect without a shell.

## Goals / Non-Goals

**Goals:**

- Settings fields for client id and secret, with an in-app guide in English and German.
- A saved pair wins over the environment and the compiled client for Connect and refresh.
- Empty settings keep today's fallback, including release builds and `scripts/install-linux-local.sh`.
- Secret in the keyring; client id in store meta; never log the secret or put it back into the field.

**Non-Goals:**

- Removing the compiled client or the Forgejo release secrets.
- Changing OAuth scopes, the loopback redirect, or the consent screen the project owns for the compiled client.

## Decisions

1. Extend `resolve_oauth` with an optional stored id and stored secret. The stored values win only when both are non-empty after trim. An id without a secret, or a secret without an id, does not override the environment or the compiled client. `client_id_from_env` stays the env-then-compile path and passes no stored pair.
2. Client id lives in store meta under its own key, not in `calendar.accounts`. The secret uses keyring service `rusty-teams.google-oauth`. Keyring calls run on a blocking thread, same as CalDAV.
3. Saving with a non-empty id and an empty secret field keeps a secret that is already in the keyring. Saving an empty id deletes the meta value and the keyring entry.
4. The settings form follows the CalDAV form: existing `control_row`, `stacked_field`, and `caption`. The secret field stays empty after load. A status line says whether the saved pair or the built-in client is active. Search terms for the calendar accounts page include the new labels, and the form source is part of the search-term test.
5. ADR 0025 records the settings override. ADR 0009 stays in force for the empty case and points at 0025.

## Risks / Trade-offs

- A saved pair that belongs to a different Google Cloud project will not refresh tokens issued by the compiled client. The save notice tells the user to connect again; the app does not disconnect for them.
- Keyring failure on save surfaces as a notice. Connect then falls through to the environment or the compiled client, because a pair is only complete when the secret can be read back.

## Migration Plan

No migration. Existing installs have no meta key and no keyring entry, so they keep the compiled or environment client.

## Open Questions

None.
