# Tasks

## 1. Google OAuth bake-in

- [x] 1.1 Resolve Google client via runtime env overriding `option_env!` and verify Connect works with `.env.google.local` on a local release build
- [x] 1.2 Add Linux/macOS local install scripts that load `.env.google.local` and refuse install when the binary lacks a client id
- [x] 1.3 Wire existing Forgejo Actions secrets `TEAMS_GOOGLE_CLIENT_ID` / `TEAMS_GOOGLE_CLIENT_SECRET` into release (and tagged) compile `env:` blocks (secrets already present in the repo; YAML still omits them) and verify the workflows reference `${{ secrets.TEAMS_GOOGLE_CLIENT_* }}` without printing values
- [x] 1.4 Document bake-in / Connect one-click behaviour in README and verify the Forgejo secret names match the design (fix any leftover “GitHub Build bakes them” wording)

## 2. Sign-in progress UX

- [x] 2.1 Publish managed-browser sign-in phases into app state and verify splash/banner text updates through opening → awaiting → finishing
- [x] 2.2 Add DE/EN locale strings for auth splash/banner phases and verify a clean rebuild never shows a raw key such as `auth.banner.connecting`
- [x] 2.3 Skip re-opening login when the managed window is already visible and verify a `LoginRequired` while visible does not spawn a second window
- [x] 2.4 Shorten watchdog login grace to ~1s on the warm path and verify Chrome returns to background promptly after success

## 3. Fonts and external browser

- [x] 3.1 Strip app FONTCONFIG from managed Chrome on Linux and verify the Microsoft login page does not use the app UI font family
- [x] 3.2 Persist preferred external browser in settings and verify Google authorize + http(s) links open there while managed Teams Chrome is unchanged

## 4. Integration check

- [x] 4.1 Cold onboarding smoke after profile wipe: splash phases during Chrome T-logo, MS login fonts OK, then shell; verify banner path on forced re-auth
- [x] 4.2 Connect Google from installed Linux and macOS builds without shell env; verify account appears and reconnect after disconnect stays one click

## Workflow follow-up

- Archive the change after review/merge (`openspec-archive-change`).
- Confirm baseline specs under `openspec/specs/` include the new `external-browser` capability and updated deltas.
