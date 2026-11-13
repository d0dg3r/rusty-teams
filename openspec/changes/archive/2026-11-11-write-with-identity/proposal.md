# Proposal

## Why

«Write with» can already replace Microsoft Copilot with a chat profile, but the composer and chat island still look and read like «Copilot». Users without an MS subscription still see Copilot branding and the island still speaks only through the Teams API.

## What Changes

- When «Write with» is a chat profile, composer rewrite and the chat header island show that profile’s identity (name + non-Copilot icon), not «Copilot».
- The chat island then answers questions through the same chat profile; context is the latest ~20 messages of the open chat as plain text (no MCP/tools).
- Composer status and error strings follow the same identity.
- With a local writer, rewrite and the island stay available without a Teams engine / without a Copilot licence.
- Leaving «Write with» empty keeps the Microsoft path including Copilot branding (as today).

Assumption (exploration detail): visible display name is the **profile name** from agent settings, not the backend model string.

## Capabilities

### New Capabilities

- (none)

### Modified Capabilities

- `agent-providers`: «Write with» controls not only the rewrite backend path but shared assistant identity and the chat island ask path.

## Impact

- UI: `crates/app/src/views/composer/rewrite.rs`, `crates/app/src/views/conversation/copilot.rs`, overflow menu in `chat_header_actions.rs`
- Settings copy optional: `settings_section.rs` (note that the island follows too)
- Context build: reuse/extend chat thread without fixed `message_id` (pattern from `message_context`, limit 20)
- Runtime: `agents::complete_text` for island ask; Microsoft `ask_copilot` only when `write_with` is empty
- Spec baseline `openspec/specs/agent-providers` after archive
