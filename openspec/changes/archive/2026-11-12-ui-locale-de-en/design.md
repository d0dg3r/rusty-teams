# Design

## Context

See `proposal.md` for motivation. App UI in `crates/app` (views, settings, notify/tray) and user notices in `crates/calling` (e.g. `CallUpdate::Notice` with English literals) are hardcoded English. Message translation and caption languages exist separately and stay untouched.

`vendor/gpui-component` already uses `rust_i18n` (`locales/ui.yml`, `set_locale` / `locale` in `vendor/gpui-component/src/lib.rs`). Appearance persistence lives in `crates/app-base/src/appearance.rs` (store meta). Notification settings similarly in `crates/app-state/src/notify/settings.rs`.

## Goals / Non-Goals

**Goals:**

- App-owned locale catalog `en` + `de` (Germany orthography in product catalog) with fallback `en`.
- Derive first start from OS locale (`de*` → `de`, else `en`), persisted override, live switch via runtime lookup.
- Stable notice IDs from calling/app-state; display text only at the UI boundary.
- Phased coverage to end state C (full product UI), no half-empty labels thanks to fallback.

**Non-Goals:**

- `de-CH` catalog, more languages in this change.
- Server content, wire protocol, captions spoken language, message translation.
- Giant upstream PR; delivery on Forgejo `origin`. Do not mix vendor component locale YAML with app strings.

## Decisions

### `rust-i18n` for the app, own catalog

Same library as `gpui-component`, own catalog (e.g. under `crates/app` or small locale module), fallback `en`. On start and preference change: set app locale and sync `gpui_kit`/`gpui-component` `set_locale` so widget strings (DatePicker, dialog defaults) do not stay English while the app shows German.

Rejected alternative: Mozilla Fluent / gettext — extra stack without benefit while vendor already has `rust-i18n`.

### Preference: auto vs fixed

Stored value: `auto` | `en` | `de`. Default without meta entry = `auto` (matches spec «no saved setting»). Persistence like appearance (store meta). UI setting under Appearance or General; show effective language clearly when `auto`.

Effective locale:

```
meta missing / auto --> OS starts with "de"? --> de : en
meta en|de       --> that exact value
```

OS locale: platform-typical query (Linux `LANG`/`LC_ALL`/`LC_MESSAGES`, Windows/macOS via existing system APIs in repo or slim addition). Only prefix `de` counts; `de_CH`, `de_DE`, `de-AT` → German (product text still Germany orthography).

### Strings at render time, not `'static` bootstrap

Visible labels via lookup at render time (`t!` or wrapper) so locale change works without restart. Const `&'static str` baked once at init only where unavoidable, then invalidate/rebind after locale change (resync tray menu).

### Call notices: IDs instead of English sentences

`CallUpdate::Notice(String)` today carries finished English text. For localization:

```
calling / app-state                 UI (crates/app)
------------------                  ---------------
NoticeId + optional args     -->    t!("call.notice....", args)
format!("Camera...: {error}") -->   key + error as arg (error may stay English internally)
```

Stable IDs for known notices (`ShareRefused`, `OnHold`, …). Dynamic errors: template key + argument. Tests in `calling` check IDs/enums, not translated sentences. UI tests can set locale and assert DE/EN text.

Rejected alternative: `t!` directly in `calling` — pulls locale catalog into a non-UI crate and couples unit tests to translations.

### Delivery phases (one change, end state C)

1. Scaffold: catalog, preference, OS default, settings control, `set_locale`, fallback.
2. Chrome: rail, settings nav/text, common dialogs (Cancel/Save/…).
3. Core surfaces: chat, calls, calendar, composer, shortcut labels.
4. Notices/tray/agents/window titles/remaining error text; calling on notice IDs.

Each phase may ship with fallback `en`; spec «full UI» is met when phase 4 is done and verify is green.

### OpenSpec vs product orthography

OpenSpec artifacts and agent text: Swiss spelling (no eszett). Product catalog `de`: Germany German including eszett. No contradiction — different text kinds.

## Risks / Trade-offs

- [Huge diff / layout tests with English strings] → phases; tests set locale or assert keys/roles; adjust `layout_guard` and visible string asserts selectively.
- [Tray/OS menus cache labels] → after locale change `sync_tray` and similar rebuilds.
- [Longer DE strings break layout] → check critical buttons in DE; shorter wording where needed, do not scale font.
- [Notice-ID migration leaves literal remnants] → inventory `CallUpdate::Notice` paths; CI or test «no new English notice literals» optional later.
- [gpui-component without `de` in `locales/ui.yml`] → missing widget keys fall back to `en`; add vendor `de` lines or accept until follow-up.

## Migration Plan

No server state. Existing installs without meta key behave like `auto` (OS). Rollback: remove preference / set `en`; code revert on fork branch. Delivery only after Forgejo `origin`.
