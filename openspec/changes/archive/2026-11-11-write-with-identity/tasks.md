# Tasks

## 1. Writer resolver and chat thread

- [x] 1.1 Provide shared resolution of «Write with» (chat profile or Microsoft) for app UI and verify with `cargo test -p app --lib` or a focused unit test for empty/`write_with` profile
- [x] 1.2 Build thread text for an open chat (max 20 non-deleted messages, senders like `message_context`) and keep unit test in `app-state` or `agents` green (`cargo test -p app-state --lib` or matching filter)

## 2. Composer branding

- [x] 2.1 In `crates/app/src/views/composer/rewrite.rs` tie working/failed/empty/text-only strings and button icon to local writer name; leave Microsoft path unchanged — verify by string review and `cargo test -p app --lib` if rewrite tests exist
- [x] 2.2 Adjust settings hint under «Write with» to mention rewrite and chat island; check manually in settings dialog

## 3. Chat island: branding and local ask

- [x] 3.1 In `copilot.rs` and `chat_header_actions.rs` derive title, tooltips, placeholder, working/failed, and logo/icon from writer — verify: with local profile no `copilot_color.svg` as identity mark
- [x] 3.2 Island ask with local writer via `complete_text` with thread+question; reachable without engine; with empty `write_with` still `ask_copilot` — verify with focused test or manual smoke (local profile vs Microsoft)
- [x] 3.3 Integration: `cargo test -p agents --lib` and `cargo test -p app-state --lib` (or tighter filters) green; short smoke: Write with → Ollama/OpenAI profile → island question and composer rewrite show profile name

## Workflow follow-up

- Archive after review and merge spec deltas into `openspec/specs/agent-providers`
- Push everyday commits to `fork`, not `origin`
