## Context

`keeps_webrtc_line` in `crates/app-base/src/diagnostics.rs` keeps lines whose text contains an audio marker (`audio_device`, `WebRtcVoiceEngine`, and similar). Windows endpoint dumps are already excluded by source line number. Pulse logs the same kind of dump as `PlayoutDeviceName`, `RecordingDeviceName`, `output: name`, and `output: guid` from `audio_device_impl.cc`. `list_devices` in `crates/calling/src/call/mod.rs` calls those APIs once a second while a call uses the platform device.

## Approach

Treat enumeration text from `audio_device_impl.cc` the same way Windows endpoint dumps are treated: do not record it. Match the message, not a line number, because the Pulse file's line numbers move between libwebrtc builds. Do not skip `audio_device_pulse_linux.cc` teardown or `webrtc_voice_engine` lines.

## Out of scope

- Slowing or removing the device poll
- Ringtone device selection
- Incoming-call accept timing
