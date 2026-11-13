# Design

## Context

See `proposal.md` — Why. Today:

- `AgentSettings.write_with` (empty = Microsoft) drives composer rewrite in `crates/app/src/views/composer/rewrite.rs` via `local_writer` → `agents::complete_text`.
- Tooltips already use the profile name; status/error strings and icons stay «Copilot» / `auto_fix_high`.
- The chat island in `crates/app/src/views/conversation/copilot.rs` is fixed to `symbols/copilot_color.svg` branding and only calls `engine.ask_copilot` (Teams Sydney).
- Agent threads with limit 20 live in `crates/app-state/src/agents/message_context.rs` — but at a fixed `message_id`. The island needs the same limit idea for the whole open chat.

## Goals / Non-Goals

**Goals:**

- One shared «active writer» resolution (profile or Microsoft) for branding and ask/rewrite.
- Island ask locally with thread text (max 20 messages), no tools.
- No Copilot logo/copy when the writer is local.

**Non-Goals:**

- No MCP/tool loop in the island.
- No provider-specific brand assets (Ollama/OpenAI logos); a generic bot symbol is enough.
- No rewrite of robot agent delegation (hover toolbar).
- Do not remove the Microsoft path.

## Decisions

### 1. Shared writer resolver

A small helper (app-side, e.g. beside agents runs handle) returns:

- `None` / Microsoft → empty `write_with`
- `Some(profile)` → valid chat profile

Composer and island read the same source. Display name = `profile.name`.

**Alternative:** Model string from `AgentBackend` — rejected because dropdown and spec fix on profile name.

### 2. Branding

| Surface | Microsoft | Local |
|---|---|---|
| Island logo / header | `copilot_color.svg` | Symbol `smart_toy` / bot (existing asset) |
| Labels / status | «Copilot …» | «{profile.name} …» |
| Composer button | `auto_fix_high` ok or same bot symbol | same non-Copilot symbol + tooltip «Rewrite with {name}» |

Overflow menu (`chat_header_actions.rs`) uses the same dynamic label string instead of `'static` Copilot text.

### 3. Island ask path

```
ask
  |
  +-- local_writer Some(profile)
  |     build thread text (newest 20 non-deleted)
  |     complete_text(system, thread + question)
  |
  +-- else
        engine.ask_copilot (as today; without engine → UNAVAILABLE)
```

System prompt: answer questions about the current Teams chat; use only the supplied thread; do not invent messages.

Thread build: `store.messages(chat_id, None, 20)` (or equivalent), sender resolution like `message_context` (`local_names` / `sender_name`). No dependency on a clicked `message_id`.

**Alternative:** Wire island to agent run + MCP — rejected (exploration decision: option 1).

### 4. Availability without engine

- Rewrite: `rewrite_available` already `local_writer.is_some() || engine` — keep/harden.
- Island button/ask: with local writer do not require engine; `ask_copilot` branch only on Microsoft path.

### 5. Settings hint

Short text under «Write with» notes that rewrite **and** the chat island follow the entry.

## Risks / Trade-offs

- [Thin context] 20 messages are not enough for long chats → mitigation: same limit as agent thread; extend later, spec stays «at most twenty».
- [Channel vs chat] Island today only with `Selection::Chat` — stays; channels out of scope.
- [Multiple island turns] Follow-up questions still get current chat thread, not necessarily island dialog history → accepted for v1; dialog turns UI-only.
- [Profile deleted] `write_with` points at missing ID → like today fallback toward Microsoft label in settings; ask should fail clearly or treat writer as missing — implementation: missing profile = no local_writer (as `local_writer` today).

## Migration Plan

No data migration: `write_with` exists. UI/ask behaviour only. Rollback = previous binary.

## Open Questions

None spec-relevant. Icon choice (`smart_toy` vs `bot`) is implementation detail.
