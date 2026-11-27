## Why

During a call the client lists audio devices about once a second. Each name lookup is logged by the platform audio device, and the diagnostics filter keeps every `audio_device` line. On Linux that is about 47 lines per second, so `diagnostics.log` rotates every few minutes and real call events are buried.

## What Changes

- Drop Linux audio-device enumeration lines (device names, guids, device counts, and the `Initialized` line from `audio_device_impl.cc`) from the diagnostics log.
- Keep Pulse teardown lines (`disconnected`, `failed`, `Terminate`) and voice-engine lines.
- The once-per-second device poll itself stays, so hotplug detection is unchanged.

## Capabilities

- **New Capabilities:** none (`skip_specs: true`)
- **Modified Capabilities:** none

## Impact

- `crates/app-base/src/diagnostics.rs` only. No call, ringtone, or UI behaviour.
