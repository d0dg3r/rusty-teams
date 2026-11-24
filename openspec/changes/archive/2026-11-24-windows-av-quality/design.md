# Design

## Context

See proposal.md. Linux and macOS already send Auto and Low on the platform device track. Windows still forced the software chain. The fork PR adds the Windows path in one commit on top of upstream `8a5c5082`. That commit is cherry-picked onto `feat/windows-av-quality` from current Forgejo `main`.

## Goals / Non-Goals

**Goals:**

- Match the Linux/macOS Auto and Low device-track rule on Windows, including a single fallback noise stage for headsets that are not 48 kHz.
- Restart a live call when the active headset endpoint returns inside the quiet period.
- Keep camera send working for YUY2 and when the hardware encoder cannot start.
- Keep the small GPU blur model on battery.

**Non-Goals:**

- Changing the Linux or macOS capture path.
- A new settings control for encoder choice, flicker, or blur model size.
- Replacing the screen-share source picker. Windows share only changes frame pacing.
- Proving the Bluetooth recovery on this Linux workstation.

## Decisions

1. **Device track for Auto and Low on every desktop OS.** The Windows flag that forced the software chain is ignored. Music mode, Off, and computer-sound sharing stay on the software chain, same as Linux.
   Alternative: keep Windows on the software chain and only tune its filters. Rejected because that path stays out of the platform echo canceller.

2. **Auto disables the platform noise suppressor on the device track and arms one hook.** The hook runs the machine-learning model on 480-sample frames. Other frame sizes, a model that is not ready, or an overloaded CPU use one platform noise-suppression stage inside the same hook. The hook stays armed while overloaded so the track is not left unfiltered.
   Alternative: disarm the hook on overload and turn the platform suppressor back on. Rejected because the device track was opened with that suppressor off.

3. **Hot-plug recovery uses the endpoint id, not only the default-device role.** The watcher reports the id for add, remove, and state changes, and reports a default change for both console and communications. If the quiet period ends and the active endpoint was among the touched ids and is still in the list, capture or playout restarts on that index even when the index did not change.
   Alternative: always restart both directions on any device event. Rejected because an unrelated device would glitch the call.

4. **Hardware H.264 is the first Windows camera encoder, with the existing software encoder as fallback.** The factory returns the software codec error when Media Foundation cannot create the encoder.
   Alternative: hardware only. Rejected because a missing encoder would stop camera video.

5. **Battery skips only the large GPU blur model.** The small GPU model stays on the ladder when a GPU device exists.
   Alternative: skip every GPU model on battery. That is the previous behaviour and is what this change replaces.

## Risks / Trade-offs

- [Hardware encoder negotiates differently from the software encoder] → Fallback on create failure. A mid-call encoder stall is not covered and needs a Windows call.
- [Headset recovery restarts a stream that was only briefly invalid] → Limited to the active endpoint id inside the existing 500 ms quiet period.
- [50 Hz flicker request is wrong for a 60 Hz room] → Best effort. A refused request does not stop the camera.
- [Vendored WebRTC encoder is Windows-only C++] → Linux and macOS builds must keep compiling with that code behind the Windows target.

## Open Questions

- Whether a mid-call hardware encoder failure, after a successful start, must renegotiate or only the create-time fallback is required.
- Whether the 150 ms settle before reselecting a just-returned endpoint is long enough for every Bluetooth stack. The spec requires a restart, not a specific wait.
