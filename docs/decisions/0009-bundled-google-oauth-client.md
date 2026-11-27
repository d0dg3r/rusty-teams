---
status: accepted
date: 2026-11-13
---

# ADR 0009: Bundled Google OAuth Desktop client

## Context

Google Calendar Connect needs an OAuth Desktop client id. Asking every user to create one in Google Cloud Console, or to export shell variables before starting the Mac `.app`, fails for Dock and Start Menu launches. A settings field for the client id would still dump Cloud Console work on end users.

Options were: env vars only, a settings field for the client id, or one project client baked into release builds.

## Decision

Official release builds compile in the project Desktop client id and client secret via `option_env!`. Runtime environment variables still override for developers. Users only click Connect Google; tokens stay on the device (see ADR 0002). `v*` tags refuse to build without the Forgejo Actions secrets for the client id (and secret).

A client id and secret saved in Settings override both the environment and this compiled client (ADR 0025). When those fields are empty, this decision still applies.

Local Linux installs use `scripts/install-linux-local.sh`, which rebuilds with `.env.google.local` when present and **requires** both `TEAMS_GOOGLE_CLIENT_ID` and `TEAMS_GOOGLE_CLIENT_SECRET`. Google Cloud Desktop clients issue a secret; without it, token refresh fails and the week grid stays empty after the first access token expires. A true public client with an empty secret remains allowed at runtime in code, but the local install gate does not ship that path.

## Consequences

- Connect works from a Dock-started macOS `.app` and from Windows/Linux installers without a terminal.
- The project owns the Google Cloud consent screen and verification path for the sensitive `calendar` scope.
- Local `cargo run` without id/secret stays Outlook-only unless the developer exports the env vars.
- The client id is visible in the binary. A secret the user types is stored in the OS keyring (ADR 0025) and must not appear in logs or be shown again after save.
- Refresh failures surface as a Google calendar load failure (banner + retry), not a silent empty week.
