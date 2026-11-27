# Proposal

## Why

On Linux, Settings > General > Teams session browser only lists Chrome, Chromium, and the Firefox family. A company that allows sign-in only in Microsoft Edge therefore cannot pick the browser that is installed. macOS already offers Edge, Brave, Helium, and Vivaldi for the same managed session.

## What Changes

- The Linux session-browser list includes Microsoft Edge, Brave, Helium, and Vivaldi when their executable is on `PATH`.
- Automatic follows the desktop entry `xdg-settings` reports for Edge (`microsoft-edge.desktop`) and Brave (`brave-browser.desktop`), even when that stem is not the executable name.
- Stopping the managed browser recognises the Linux process name `microsoft-edge`.
- Flatpak, Snap, Opera, and WSL stay unchanged.

## Capabilities

### New Capabilities

- None.

### Modified Capabilities

- `linux-sign-in`: the supported Chromium session browsers on Linux include Edge, Brave, Helium, and Vivaldi, and Automatic can select Edge and Brave from their desktop entries.

## Impact

- Linux settings list and the browser chosen for sign-in. macOS already lists these browsers.
- Same Chromium launch flags and the same managed profile as Chrome. No new surface, colour, or spacing.
- Upstream issue 130 is the Edge report. This change is the fork behaviour; an upstream pull request is a later thin slice.
