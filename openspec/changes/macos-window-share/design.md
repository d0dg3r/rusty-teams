# Design

## Context

Upstream pull request 97 is unmerged. Its head is merged onto Forgejo `main`. The ScreenCaptureKit window capturer lives in `vendor/webrtc-sys`. `scripts/build-macos.sh` from that pull request builds `aarch64-apple-darwin` only and writes `target/aarch64-apple-darwin/release/teams-macos.zip`.

## Goals / Non-Goals

**Goals:**

- Window share on macOS opens the system picker and survives cancel, stop, and a closed window.
- The Forgejo release job publishes that arm64 zip under the existing asset name.

**Non-Goals:**

- Re-enabling GitHub-hosted builds. `.github/workflows/build.yml` stays the Forgejo stub.
- Intel macOS. ScreenCaptureKit's content-sharing picker needs macOS 14, and the pull request drops the x86_64 slice.
- Linux or Windows share behaviour.

## Decisions

1. Take the pull request's capturer, calling-crate wiring, and macOS build script.
2. Keep `.github/workflows/build.yml` as the mirror stub.
3. Point `.forgejo/workflows/release-macos.yaml` at `target/aarch64-apple-darwin/release/teams-macos.zip` and install only the arm64 Rust target. The uploaded name stays `rusty-teams-<ver>-macos-universal.zip`.

## Risks / Trade-offs

- Intel Macs no longer get a slice in this package.
- The asset name still says universal. The changelog states that the binary is arm64.

## Migration Plan

Tag `v0.6.1-joe.4` on Forgejo. Rollback is the previous tag.

## Open Questions

None.
