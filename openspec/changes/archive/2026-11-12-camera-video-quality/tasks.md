# Tasks

## 1. Quality model and capture

- [x] 1.1 Introduce `VideoQuality` (Auto / 720 / 1080) and derive capture ceiling in `calling`; Verify: unit test for ceiling mapping
- [x] 1.2 Point `pick_format` / `fit_widescreen` / open fallback at the ceiling (prefer 1080 for Auto/1080); Verify: `cargo test -p calling --lib` filter format choice / widescreen
- [x] 1.3 Adapt existing capture tests to new preference; Verify: `cargo test -p calling --lib camera` (or tighter filter) green

## 2. Send and stage limits

- [x] 2.1 Set stage receive limits for Auto/1080 to 1080p class (`max-fs` 8160, camera-suitable `max-fps`/`max-mbps`); 720 keeps old stage budgets; Verify: tests in `video_layout` for stage body
- [x] 2.2 Keep send capabilities tied to actual capture size and clamp to ceiling; Verify: `send_capabilities_body` tests / reporter
- [x] 2.3 Leave small-tile and screen-share limits unchanged; Verify: existing small/screen assertions still green

## 3. Setting, UI, apply in call

- [x] 3.1 Persist video quality (default Auto) like device/call settings; Verify: roundtrip test or settings serialization
- [x] 3.2 Auto/720p/1080p choice in camera menu (call + prejoin); Verify: manual UI smoke or view test if present
- [x] 3.3 Changing tier restarts capture and updates stage requests without app restart; Verify: focused calling/app test or documented smoke step
- [x] 3.4 Integration: `cargo test -p calling --lib` and relevant `cargo test -p app …` filters green
