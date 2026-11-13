# Design

## Context

See proposal.md — Why. Calendar Connect already uses loopback + PKCE; release packaging moved to Forgejo while `.github/workflows/build.yml` is a mirror stub. Managed Chrome on Linux inherits process env, including a private `FONTCONFIG_FILE` used for app emoji fonts. Sign-in progress today is mostly a generic “connecting” state, not tied to browser lifecycle.

## Goals / Non-Goals

**Goals:**

- One compile-time resolve path: runtime `TEAMS_GOOGLE_CLIENT_*` overrides `option_env!` baked values.
- UI phases driven by browser lifecycle events on Linux/macOS managed Chrome.
- External opens (links + Google authorize) share one preference store key; managed Teams Chrome stays separate.
- Forgejo release/tag builds fail closed without the client id secret.

**Non-Goals:**

- Google Cloud consent-screen branding, verification, or test-user enrollment in-repo.
- Replacing managed Chrome with a built-in WebView for Microsoft login.
- Baking secrets into the GitHub mirror workflow stub.
- Tracking ADRs under `docs/` while that tree remains gitignored on main (decision text lives here).

## Decisions

1. **Bake Desktop client via `option_env!`**  
   Release CI exports secrets into the compiler env. Alternatives: settings field (rejected — forces Console work on users) or env-only (rejected — Dock/Start Menu have no shell env).

2. **Forgejo is the bake-in SoT**  
   Inject `TEAMS_GOOGLE_CLIENT_ID` / `TEAMS_GOOGLE_CLIENT_SECRET` into `.forgejo/workflows` release (and tagged) jobs. Keep `.github/workflows/build.yml` as the no-op mirror stub; do not revive full GitHub build matrices for this change.

3. **Browser sign-in state → UI**  
   Publish opening / awaiting / finishing / failed from the managed-browser controller into app state; splash and connection banner map those phases to locale strings. Skip re-raising login when the managed window is already visible.

4. **Login grace ~1s on warm path**  
   Watchdog grace after successful MSAL session short enough for reconnect, without removing the need for a brief settle after first paint of the login window.

5. **Strip app FONTCONFIG for managed Chrome (Linux)**  
   Clear `FONTCONFIG_FILE` / related vars on the Chrome child so Microsoft pages use system fonts. Keep FONTCONFIG for the GPUI process only.

6. **Preferred external browser in settings meta**  
   Persist a browser id/path in store meta; `open_external_url` resolves preference then falls back to system default. Google authorize and in-app http(s) links share this helper; managed Chrome launch does not.

7. **Locale rebuild**  
   `app-base` build script reruns on locale file changes so rust_i18n embeds stay current (avoids raw keys like `auth.banner.connecting` in UI).

## Risks / Trade-offs

- [Client id visible in binary] → Acceptable for Desktop clients; never log or store the client secret in UI/store; secret only in CI env / local `.env.google.local` (gitignored).
- [Consent screen still shows GCP app name] → Operator renames consent / uses the `rusty-desk` project client; documented outside specs.
- [Forgejo secrets missing on tag] → Job fails before publish; install scripts refuse release install without a baked or env client.
- [Short grace races slow IdP pages] → Failed/awaiting phases still cover long waits; grace only after success signal.

## Migration Plan

1. Land code + OpenSpec on `pr/google-oauth-login-ux`.
2. Set Forgejo Actions secrets; add env to release/test compile steps.
3. Rebuild/install with `.env.google.local` for local smoke; wipe profile only when testing cold onboarding.
4. Archive change into `openspec/specs/` after merge.
5. Rollback: drop baked env from CI and ship without Google Connect (Outlook-only) or revert the release tag build.

## Open Questions

- Whether Windows managed-browser sign-in needs the same splash/banner phases in this change or a follow-up (Linux/macOS are in scope now).
