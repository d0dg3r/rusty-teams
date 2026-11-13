# Tasks

## 1. Locale scaffold

- [x] 1.1 App catalog `en`/`de` with `rust-i18n` (own catalog, fallback `en`) and wire start hook; sync `gpui-component`/`gpui_kit` `set_locale`. Check with `cargo test -p app --lib ui_locale` (or tighter filter once module exists).
- [x] 1.2 Load/save preference `auto`|`en`|`de` (store meta like appearance) and derive effective locale from OS (`de*` → `de`, else `en`). Check with `cargo test -p app-base --lib ui_locale` or the crate holding the preference.
- [x] 1.3 Settings control for UI language (including label when `auto`); change sets locale live and persists. Check with `cargo test -p app --lib ui_locale_settings`.

## 2. Chrome and settings

- [x] 2.1 Rail, sidebar tabs, and settings navigation/search terms via locale lookup. Check: visible labels under locale `de` and `en` in `cargo test -p app --lib ui_locale_chrome`.
- [x] 2.2 Common dialog actions and settings sections General/Appearance/Notifications on catalog. Check with `cargo test -p app --lib ui_locale_settings`.

## 3. Core surfaces

- [x] 3.1 Localize chat/conversation UI (composer hints, menus, tooltips). Check with `cargo test -p app --lib ui_locale_chat`.
- [x] 3.2 Localize call UI (controls, prejoin, layout hints, tooltips). Check with `cargo test -p app --lib ui_locale_call`.
- [x] 3.3 Localize calendar and remaining core dialogs. Check with `cargo test -p app --lib ui_locale_calendar`.

## 4. Notices, tray, agents, rest

- [x] 4.1 Stable notice IDs (plus args) in `calling`/`app-state` instead of English notice literals; UI resolves text. Check with `cargo test -p calling --lib notice_id` and `cargo test -p app --lib ui_locale_notice`.
- [x] 4.2 Localize tray menu, toasts, window titles, and agent UI; resync tray after locale change. Check with `cargo test -p app --lib ui_locale_tray`.
- [x] 4.3 Cover remaining product user text (shortcut labels, leftover error hints); missing DE keys fall back to EN. Check with `cargo test -p app --lib ui_locale_fallback`.

## 5. Integration

- [x] 5.1 `cargo test -p app --lib ui_locale`, `cargo test -p calling --lib notice_id`, and phase 1 preference tests green together.
- [x] 5.2 Manual: fresh data without meta → system `de*` shows DE; override EN survives restart; switch DE↔EN without app restart; one call notice and tray menu follow locale. Chat message body unchanged.

## Workflow follow-up

- After `/opsx-apply` and review archive the change (`/opsx-archive`) so `ui-locale` lands under `openspec/specs/`.
