# Design

## Context

`open_picked_format` started with `Closest(NV12 1080p)`. On the C930e there is no NV12; nokhwa lands on YUYV 1080p@5. `compatible_camera_formats` often fails (`Failed to Fufill`), so the 5-fps stream remains. MJPEG 1080p@30 and 720p@30 exist on the device but were excluded from `pick_format` (`DIRECT_FORMATS = NV12|YUYV`).

## Goals / Non-Goals

**Goals**

- Never open below 30 fps when the device offers 30 fps in any usable format.
- MJPEG 1080p/720p as preferred HD path on USB 2.0 cameras.
- Fast decode MJPEG → I420 with reused buffers.
- Measurability in the call report.

**Non-Goals**

- NVENC/VAAPI encoder in this pass.
- Receive/render path optimization before own capture fps is correct.

## Decisions

1. **Exact candidates with fps gate:** After each open check `frame_rate() >= 30`; else next candidate (MJPG HD → raw 30 fps → AbsoluteHighest).
2. **MJPEG in `pick_format`:** At same resolution and 30 fps raw (NV12 > YUYV) stays preferred; else MJPEG.
3. **Decode:** `zune-jpeg` → RGBA → `abgr_to_i420`; nokhwa `decode_image` only for other formats.
4. **UVC:** `exposure_dynamic_framerate=0`, `power_line_frequency=50` best effort, log errors only.

## Risks / Trade-offs

- MJPEG decode costs CPU; at 1080p@30 must stay < ~15 ms/frame — else lower capture (720p) as fallback.
- AbsoluteHighest can trigger property fails again — last resort only.

## Migration

No data migration. After release restart the app; check call report for `MJPG … @30` and ~30 encoded frames/s.
