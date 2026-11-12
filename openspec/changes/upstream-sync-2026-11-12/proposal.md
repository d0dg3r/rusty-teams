# Proposal

## Why

Upstream (`danieldaeschle/rusty-teams`) ist seit dem letzten Merge-Base um viele Calls-, Chat- und MCP-Features voraus. Der Fork braucht diesen Stand, ohne Locale, Camera/Wayland, Agent-Providers, Forgejo-CI und Linux-Fixes zu verlieren.

## What Changes

- Call-/Meeting-Fenster, Gallery-Paging, Join-Preview und Call-Toolbar/Layout wie neues Teams übernehmen
- MCP: `write_message` / `add_reaction`, Meeting-Organisation, Free-time, Review-Settings und persistente Meeting-Proposals
- Chat: Message-Animationen, Typing-Indicator im Chat, Out-of-office Notice, Context-Menüs, Splash, native Manage-Team-Seite
- Store-Migrationen `0030` / `0031` und Workspace-Version `0.3.0`
- Fork-Verhalten bleibt: UI-Locale DE/EN, Camera-Qualität, Wayland ScreenCast, Google Calendar, Agent-Providers, Forgejo-Release/CI, gebündelte CBDT-Emoji-Font

## Capabilities

### New Capabilities

- `call-window-layout`: Eigenes Call-/Meeting-Fenster, Toolbar-Reihenfolge, Gallery-Paging und Join-Preview
- `mcp-meetings-write`: MCP-Tools für Schreiben/Reaktionen, Free-time und Meeting-Organisation inkl. persistenter Proposals
- `chat-presence-motion`: Message-Erscheinen, Typing im Chat, Out-of-office Notice und Start-Splash
- `manage-team-page`: Native Team-Verwaltungsseite mit Member-Liste

### Modified Capabilities

- `call-media-negotiation`: Upstream Relay-/Answer-Fixes und Fullband-Opus mit Fork Camera-/1:1-Negotiation verbinden
- `screen-share`: Upstream Share-Stop-/Windows-Fixes mit Wayland ScreenCast Portal behalten
- `camera-video-quality`: Camera Auto/720p/1080p und 30‑fps-Pfad bleiben nach Call-UI-Sync erhalten
- `ui-locale`: Neue Upstream-UI-Strings werden über Locale-Keys abgedeckt (Fallback Englisch)

## Impact

- Heisse Zonen: `crates/app` Call-/Chat-Views, `crates/app-call-model`, `crates/calling`, `crates/mcp`, `crates/store` Migrationen, `Cargo.toml`
- Releases bleiben Joe-Tags (`v0.3.0-joe.N`) auf Forgejo; kein Upstream-PR aus diesem Sync
