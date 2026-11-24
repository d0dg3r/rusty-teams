# Proposal

## Why

Windows calls still send the microphone through the software audio chain, so Auto and Low miss the platform echo canceller, Bluetooth headsets drop out of the call when the profile switches, and camera and screen video stay on a software path that Linux already left behind.

## What Changes

- On Windows, noise suppression Auto and Low use the native WebRTC device track (WASAPI). Music mode, Off, and computer-sound sharing stay on the software chain.
- Auto runs DeepFilterNet alone on a 48 kHz device track. A 16/32 kHz headset, a model that is still loading, or an overloaded CPU falls back to one WebRTC noise-suppression stage. Low uses that WebRTC stage only. The two stages do not stack.
- A Bluetooth or headset endpoint that drops and returns during the device-change quiet period restarts capture and playout on the same endpoint. Default-device changes cover both the console and the communications role.
- Windows cameras are identified by a stable Media Foundation link, YUY2 frames convert to I420, and the open path asks for 50 Hz anti-flicker and keeps auto-exposure from dropping the frame rate.
- Outbound camera video prefers a Media Foundation hardware H.264 encoder and falls back to the software encoder when the hardware path cannot start.
- On battery with a GPU, background blur still uses the small GPU model and skips only the large GPU model.
- Windows screen capture paces frames with a high-resolution timer.

## Capabilities

### New Capabilities

- `windows-call-audio`: Windows microphone path, noise suppression, and headset hot-plug recovery during a call.
- `windows-camera`: Stable Windows camera identity, YUY2 conversion, and UVC anti-flicker while the camera is open.
- `windows-h264`: Hardware H.264 for the outbound camera with a software fallback.
- `windows-background-blur`: Which blur model runs on a Windows GPU while the machine is on battery.

### Modified Capabilities

None. Linux and macOS call-audio requirements stay as they are. This change makes Windows follow the same Auto and Low device-track rule those specs already state for their platforms.

## Impact

- `crates/calling` audio, camera, screen pacing, and blur model choice.
- Vendored WebRTC: Media Foundation H.264 encoder and YUY2 to I420.
- Source: GitHub fork PR https://github.com/d0dg3r/rusty-teams/pull/1, commit `89161df8`, already cherry-picked onto local branch `feat/windows-av-quality`.
- Live proof still belongs on a Windows machine with a Bluetooth headset. This workspace cannot run that call.
