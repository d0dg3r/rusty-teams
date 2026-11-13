# Design

## Context

Siehe proposal.md — Why. Fork und Upstream sind seit `dc7f29f` divergiert (~59 Upstream / ~35 Fork). Sync ist ein Merge auf `sync/upstream-2026-11-12`, Push nur nach Forgejo `origin`.

## Goals / Non-Goals

**Goals:**
- Upstream Call-Fenster, Chat-Motion, MCP-Meetings und Manage-Team lauffähig im Fork
- Fork-Pfade (Locale, Camera-Qualität, Wayland-Share, Agent-Providers, Forgejo-CI, CBDT-Emoji) erhalten
- Workspace `0.3.0`, Store `0030`/`0031`, CHANGELOG Joe-Eintrag

**Non-Goals:**
- Kein Upstream-PR mit Fork-Mischung
- Kein Rebase der 35 Fork-Commits
- Keine vollständige Neu-Lokalisierung jedes Upstream-Strings in einem Commit (Fallback EN ok, Nachzug erlaubt)

## Decisions

1. **Merge statt Rebase** — History hat bereits Merge-Commits; Konflikte einmal auf Sync-Branch lösen.
2. **Upstream-UI-Struktur, Fork-Media-Patches** — Call-/Chat-Chrome von Upstream; Camera/SDP/Wayland/Locale gezielt behalten.
3. **Emoji-Font ours** — Binary `NotoColorEmoji.ttf` bleibt die Fork-CBDT-Variante; Upstream COLRv1-Fix bleibt wo Code-seitig.
4. **call_mini löschen** — Upstream entfernt Mini zugunsten Call-Window; Fork folgt.
5. **OpenSpec grobe Capabilities** — vier neue + vier modifizierte Specs statt 59 Einzel-Changes.

## Risks / Trade-offs

- [Risk] ~73 Konfliktdateien, Build bricht nach naive theirs → Mitigation: Media-Dateien manuell mergen, dann `cargo test`
- [Risk] Locale-Lücken bei neuem Chrome → Mitigation: EN-Fallback; Follow-up Keys
- [Risk] Camera vs. neues Call-Window API-Drift → Mitigation: Spec `camera-video-quality` + gezielte Tests in calling/app-state

## Migration Plan

1. Merge auf Sync-Branch, Konflikte, Compile/Test
2. Merge nach `main`, Push `origin`
3. Optional Release-Tag `v0.3.0-joe.N` nach Smoke
4. Rollback: Sync-Branch nicht mergen bzw. Revert-Merge auf `main`
