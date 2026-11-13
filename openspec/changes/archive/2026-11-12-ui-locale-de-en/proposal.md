# Proposal

## Why

The whole app chrome is hardcoded English today. Users with German system locale and the fork audience need a consistently German UI without losing the English baseline and upstream compatibility. Message translation and caption languages already exist; app UI language is missing.

## What Changes

- The app offers two UI languages: English and German (Germany orthography in the product catalog).
- On first launch the UI follows OS locale: system locale `de*` → German, else English.
- Users can override UI language permanently in settings; the choice is stored and applies on the next start.
- Switching updates visible UI text without restart where strings resolve at runtime.
- All product-side UI strings are localized: navigation, settings, dialogs, menus, tooltips, shortcuts, toasts, tray, agent UI, and call/error notices.
- Call and similar user notices carry stable keys; display text is produced at the UI boundary in the active locale.
- Missing translations fall back to English instead of empty or raw keys.
- Unchanged outside scope: chat/server content, Adaptive Cards from server, OS device names, wire protocol strings, captions spoken language, existing message translation.

## Capabilities

### New Capabilities

- `ui-locale`: choose app UI language, derive from OS locale, persist, and apply across the whole app chrome (English and German).

### Modified Capabilities

- None. Message translation and caption languages stay separate, unchanged behaviour areas.

## Impact

- UI crate (`crates/app` and related views), persistence like appearance/settings meta, tray and toast text.
- Call notices and similar user text in `crates/calling` / `app-state`: move from English literals to stable notice IDs, resolve in the UI.
- Catalog and locale runtime like existing `rust-i18n` pattern in `vendor/gpui-component` (own app catalog, do not mix vendor YAML).
- Layout/UI tests that expect English visible strings must become locale-aware or assert keys/IDs.
- Delivery on fork (`origin` Forgejo). No giant upstream PR of the whole i18n wave; infrastructure can be offered later as its own slice.
