# Tasks

## 1. Land the fork PR on a local branch

- [x] 1.1 Cherry-pick `89161df8` from `G3Rn0t/rusty-teams` `windows-av-quality` onto `feat/windows-av-quality` from current Forgejo `main`
- [x] 1.2 Keep music mode, Off, and computer-sound sharing on the software chain
- [x] 1.3 Keep the hardware H.264 path behind the Windows build so other targets still compile the vendored tree

## 2. Behaviour covered by the PR commit

- [x] 2.1 Auto and Low use the Windows device track, with one fallback noise stage for non-48 kHz, warm-up, and overload
- [x] 2.2 Active headset endpoint that returns inside the quiet period restarts capture or playout
- [x] 2.3 Windows camera identity, YUY2 conversion, and best-effort anti-flicker
- [x] 2.4 Hardware H.264 encoder with software fallback
- [x] 2.5 Small GPU blur model stays available on battery

## 3. Verify

- [x] 3.1 `openspec validate windows-av-quality`
- [x] 3.2 Portable unit tests for device-track selection, hook arming, blur rungs, and device-change debounce (`cargo test -p calling`)
- [x] 3.3 Windows live call already run on the fork PR: `cargo test -p calling` and `cargo build --release -p app` on MSVC, plus a Teams call with an MMX 200 wireless headset (power off and on mid-call, recovery in `diagnostics.log`) and the built-in mic array
