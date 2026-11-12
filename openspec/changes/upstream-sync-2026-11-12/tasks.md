# Tasks

## 1. Merge und Konflikte

- [x] 1.1 Branch `sync/upstream-2026-11-12` von `main` und `git merge upstream/main` (Verify: Merge gestartet, Konflikte gelistet)
- [x] 1.2 Call-/Chat-UI-Konflikte zugunsten Upstream lösen; `call_mini` entfernen; Emoji-Font ours (Verify: keine Konfliktmarker in diesen Dateien, `git add`)
- [x] 1.3 Calling-/Camera-/Wayland-/SDP-Konflikte mergen und Fork-Pfade behalten (Verify: keine Marker; Camera-/Wayland-Symbole noch vorhanden)
- [x] 1.4 Shell, Conversation, Main, Calendar, MCP, Agent-API Konflikte lösen (Verify: keine Konfliktmarker unter `crates`)

## 2. Version und Doku

- [x] 2.1 Workspace-Version `0.3.0` und Store-Migrationen `0030`/`0031` (Verify: `Cargo.toml` + `migrations.rs`)
- [x] 2.2 CHANGELOG Joe-Eintrag für Upstream-Sync (Verify: Abschnitt unter `0.3.0-joe.6` oder nächstem Tag)

## 3. Verify und Integration

- [ ] 3.1 `cargo test` für store, mcp, calling und weitere grünen Suites (Verify: Tests pass)
- [ ] 3.2 Sync-Branch nach `main` mergen und nach `origin` pushen (Verify: `origin/main` enthält Upstream-Merge)

## Workflow follow-up

- OpenSpec-Change nach stabilem Main archivieren (`/opsx-archive`)
- Locale-Keys für neues Upstream-Chrome nachziehen
- Smoke: Locale, 1:1 Call, Wayland-Share
