## Context

`apply_sound_output` stores a `DeviceChoice` key. `AudioDevice::key` in `crates/calling/src/devices.rs` uses the guid, or the name when the guid is empty. Pulse leaves the guid empty, so the stored key is the sink description. `open_sink` in `crates/app-base/src/notify/platform/linux_sound.rs` searches cpal output devices. That module is also built on macOS.

## Decisions

1. Decode the tone with rodio, as today. On Linux, write the samples to a Pulse playback stream aimed at the sink name whose description or name matches the key. cpal stays the fallback and the macOS path.
2. Match by exact description or name after trimming, ASCII case-fold, and stripping one leading `default:` prefix. Do not use a substring match, so a Game sink is not selected for a Chat key.
3. Remember the last key that failed to match and do not log that same key again.
4. Depend on `libpulse-binding` and `libpulse-simple-binding` only for `cfg(target_os = "linux")`.

## Out of scope

- Changing how the in-call WebRTC playout device is selected
- macOS or Windows device lookup
