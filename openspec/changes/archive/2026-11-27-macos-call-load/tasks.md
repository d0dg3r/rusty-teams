# Tasks

## 1. Send limit

- [x] 1.1 Store a send limit that arrives while the camera or the share is not sending, and apply it from `start_camera`, `start_share`, and the existing frame-size refresh.
- [x] 1.2 Add a test: a camera limit applied while the camera is off is on the sender after the camera starts, without a second request.

## 2. macOS host load

- [x] 2.1 Add a host-load line formatter and a macOS sampler (thread CPU delta, effect flags, thermal state). Record it every two seconds on macOS only.
- [x] 2.2 Test the formatter: thread name, CPU delta, effect flags, and thermal word. Test that the Linux and Windows build of the recorder adds no host-load line.

## 3. Verify

- [x] 3.1 `cargo test -p calling --lib video_send host_load`
- [x] 3.2 Add the camera-on minute to `docs/macos-smoke.md`. Do not start an AVFoundation or NV12 rewrite. The minute itself runs on an Apple Silicon Mac; this Linux session did not run it.
