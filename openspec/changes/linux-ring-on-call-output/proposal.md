## Why

The saved call output on Linux is the Pulse sink description (the platform audio device reports an empty guid, so the key is the friendly name, for example "Headset Game"). Ringtone and ringback look that key up in the cpal/ALSA device list. ALSA does not list those Pulse sinks under that name, so every tone logs that the output was not found and plays on the system default instead.

## What Changes

- On Linux, play call tones on the Pulse sink whose description or name matches the saved output key.
- Matching ignores ASCII case and a leading `default:` prefix. "Game" and "Chat" stay different sinks.
- When Pulse is unavailable or no sink matches, play on the system default output.
- Log a missing key at most once per distinct key, not on every tone.

## Capabilities

### New Capabilities

### Modified Capabilities

- `call-tones`: a selected Pulse sink counts as the selected output for ringtone and ringback on Linux.

## Impact

- Linux tone playback in `crates/app-base`. macOS and Windows keep their current output lookup.
