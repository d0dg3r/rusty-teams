# Design

## Context

See `proposal.md` for motivation. Call tones go through `sound_cache` into `platform::play_mp3` / `play_mp3_until`. Windows implements those in `windows_impl.rs`. Linux and macOS currently use empty stubs in `stub.rs`, even though the MP3 files are already cached.

Upstream commit `5c80288` already ships `linux_sound.rs` (rodio) for Linux only. The fork has not merged that yet. The Echo bot add runs in a detached task whose `Result` is dropped; `exchange` puts the HTTP body into `Error::Signaling` but only records `HTTP {status}` on the timeline. `CallSpec::Echo` waits on `CalleeGate` for one callee, so a synchronous 400 never opens the gate and never fails the call.

## Goals / Non-Goals

**Goals:**

- Reuse upstream's Linux rodio player; extend the same module to macOS.
- Surface the Echo bot add failure (status + body) on the call timeline / report.
- End the Echo call promptly with a notice when the add fails; connect when it succeeds (including creating the bot 1:1 thread when the probe finds none, if that is what the server requires).

**Non-Goals:**

- Reimplementing a second Linux sound path.
- macOS code signing / hardened runtime.
- Making the test call work on hosts with no microphone.
- Changing Windows tone playback.

## Decisions

### Merge upstream for Linux tones

Take `linux_sound.rs`, the Linux `rodio` dependency, and the stub re-exports from `upstream/main` via a fork-branch merge. Alternative: cherry-pick only `5c80288` — rejected because later upstream chat-service and v0.4.0 pieces are useful and the conflict cost is paid once either way.

### Share the Linux module with macOS

Rename is unnecessary: keep `linux_sound.rs` (or a neutral name only if a rename is free) and gate it with `cfg(any(target_os = "linux", target_os = "macos"))`, plus a matching `rodio` target dependency for macOS. CoreAudio is rodio/cpal's macOS backend. Alternative: duplicate Windows helpers into a shared crate — more churn for the same sink-open logic upstream already has for Linux.

### Diagnose Echo 400 before inventing the fix

First change: record the full signaling error (status + body prefix) on the timeline when `add_echo_bot` fails. Rerun the test call, read the reason, then adjust the request (most likely create the Echo 1:1 chat on the chat service and pass `groupChat`). Graph `oneOnOne` chat creation expects AAD users and must not be used for the bot MRI.

### Fail-fast via channel back into the call loop

Replace the fire-and-forget spawn with a path that delivers the add `Result` into the same loop that drives `CalleeGate` (oneshot / mpsc, or await before entering the wait). On `Err`, emit a notice and end the call. Alternative: rely on `addParticipantFailure` callbacks — rejected because a synchronous HTTP 400 never produces that callback.

## Risks / Trade-offs

- [Upstream merge conflicts with Google OAuth / sign-in] → Resolve on the fork branch; keep fork-only auth intact.
- [ALSA / CoreAudio device open fails] → Fall back to the default sink (upstream Linux behaviour); log and stay silent rather than panic.
- [Creating a bot chat is rejected by the chat service] → Fail-fast notice still ends the call; timeline keeps the server reason for a follow-up.
- [macOS hosts without a mic] → Out of scope; tones can still ring, Echo media cannot.

## Migration Plan

No data migration. Users pick up tones and Echo behaviour on the next build. Rollback is a revert of the fork branch.
