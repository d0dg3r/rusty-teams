# Proposal

## Why

The day and week views today scroll once to a fixed 08:00 and do not follow the current time. On open and on «Today» you often land far from «now»; the now line only moves when something else happens to redraw. The calendar should match local time.

## What Changes

- When opening the day/week view and on «Today», the viewport scrolls so the current time is visible (not fixed at 08:00).
- The now line updates on the clock tick while the view stays open.
- While the user does not scroll vertically manually, the view stays aligned to the current time; after manual scroll the position holds until «Today» or opening the view again resets alignment.
- Month view unchanged (no hour grid).
- No **BREAKING** change to data or APIs.

## Capabilities

### New Capabilities

- `calendar-now-view`: Align day/week grid to local time (scroll, now line, follow without manual scroll).

### Modified Capabilities

- (none)

## Impact

- UI: `crates/app/src/views/calendar_view.rs` (scroll offset, tick, detect manual scroll).
- Optional light tick via GPUI/app timer; no calendar API change.
- Independent of the `google-calendar` change.
