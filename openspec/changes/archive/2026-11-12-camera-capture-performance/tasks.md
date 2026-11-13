## 1. Format choice 30 fps

- [x] 1.1 `pick_format` allows MJPEG; raw (NV12>YUYV) preferred only at same height/30 fps; C930e fixture test
- [x] 1.2 Open: exact candidates (MJPG HD → raw 30 fps), after open check `frame_rate() >= 30`; AbsoluteHighest last resort only

## 2. MJPEG decode

- [x] 2.1 `zune-jpeg` → RGBA → `abgr_to_i420` with buffer reuse in `start_camera` / `direct_i420`
- [x] 2.2 Budget test (ignored, release): 1080p decode+convert < 20 ms

## 3. UVC + telemetry

- [x] 3.1 After open: `exposure_dynamic_framerate=0`, `power_line_frequency=50` best effort
- [x] 3.2 Timeline: chosen format; stats: capture fps / decode ms where wired

## 4. Verify

- [x] 4.1 `cargo test -p calling --lib camera` + ignored hardware open
- [x] 4.2 Build release `0.3.0-joe.4` and install to `/usr/local/bin/rusty-teams`
