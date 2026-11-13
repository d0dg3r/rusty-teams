# Proposal

## Why

Dock- and Start-Menu launches cannot rely on shell-exported Google OAuth env vars, so Calendar Connect fails for real installs. Separately, Microsoft sign-in on Linux/macOS leaves the user without clear progress while managed Chrome is opening or waiting, and app fontconfig can make the Microsoft login page show the wrong UI fonts.

## What Changes

- Bake the project Google OAuth Desktop client into official release builds so Connect Google is one click; runtime env still overrides for developers.
- Surface managed-browser sign-in progress in the splash and connection banner (opening / awaiting / finishing / failed).
- Shorten the post-login watchdog grace so a warm signed-in session returns to the shell faster.
- Add a preferred external browser setting for opening http(s) links and the Google OAuth authorize URL (managed Teams Chrome stays separate).
- Keep managed Chrome free of the app’s private FONTCONFIG so Microsoft login uses system fonts.
- Wire Forgejo release/test workflows to inject `TEAMS_GOOGLE_CLIENT_*` secrets at compile time (GitHub `.github/workflows/build.yml` stays a no-op mirror stub).

## Capabilities

### New Capabilities

- `external-browser`: User-preferred browser for external http(s) links and Google OAuth authorize pages (not the managed Teams Chrome session).

### Modified Capabilities

- `calendar-accounts`: Official builds MUST ship a project Desktop client so Connect Google works without developer env vars; reconnect stays one click; tokens remain on device.
- `linux-sign-in`: Splash/banner MUST reflect managed Chrome sign-in phases; login grace shortened for warm path; managed Chrome MUST NOT inherit the app’s private fontconfig.
- `macos-sign-in`: Same sign-in progress and external-open behaviour expectations as Linux where the managed browser flow applies.

## Impact

- OAuth resolve path in chatsvc (`option_env!` + runtime env), Calendar Connect UI, local install scripts.
- App state / UI: browser sign-in events, splash, connection banner, General settings, locale strings.
- Browser launch: strip app FONTCONFIG on Linux; watchdog login grace; external URL opener.
- CI: Forgejo release (and tagged) builds need `TEAMS_GOOGLE_CLIENT_ID` / `TEAMS_GOOGLE_CLIENT_SECRET` secrets; Google Cloud consent screen branding and test users remain operator-owned outside the repo.
- Docs under `docs/` stay gitignored on this tree; decision context for the baked client lives in design.md (and a local ADR draft if kept on disk).
