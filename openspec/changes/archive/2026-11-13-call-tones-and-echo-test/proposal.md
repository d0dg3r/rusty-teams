# Proposal

## Why

On Linux and macOS the client caches ringtone and ringback MP3s but never plays them, so incoming calls and outgoing dialling are silent. The Echo test call also stalls forever in «connecting» after the bot add fails with HTTP 400, instead of connecting or ending with a visible error.

## What Changes

- Incoming ringtone, outgoing ringback, and other call tones play through the system audio output on Linux and macOS (same behaviour Windows already has).
- The Echo test call either attaches the Echo bot and connects, or ends promptly with a user-visible notice when the bot add fails.
- Diagnostics for a failed Echo bot add include the server reason so operators can see why the add was rejected.

## Capabilities

### New Capabilities

- `call-tones`: Audible ringtone, ringback, and other call tones on Linux and macOS through the selected (or default) system output.
- `echo-test-call`: The built-in Echo / audio test call either reaches a connected state with the Echo bot or ends with a clear failure notice.

### Modified Capabilities

*(none)*

## Impact

- Notification sound playback on Linux and macOS (rodio / platform audio).
- Call signaling for the Echo bot add, including timeline / call-report diagnostics and fail-fast end of the call.
- Delivery on the fork (`origin`). Linux tones already exist upstream; macOS tones and the Echo fail-fast path are thin upstream-worthy slices.
- Out of scope: fixing microphone absence on hosts without an input device; macOS code signing / hardened runtime.
