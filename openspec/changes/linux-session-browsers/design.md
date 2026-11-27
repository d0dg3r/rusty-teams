# Design

## Context

`LINUX_CHROME_NAMES` in `crates/browser/src/config.rs` is both the launch search order and the Settings list on Linux (`installed_in` in `crates/browser/src/sign_in_choice.rs`). `desktop_entry_match` compares the desktop-file stem to that executable name. On this machine Edge is `/usr/bin/microsoft-edge-stable` with `microsoft-edge.desktop`, and Brave is `/usr/bin/brave` with `brave-browser.desktop`. `is_chrome_image` already accepts Brave, Helium, Vivaldi, `Microsoft Edge`, and `msedge`, but not the Linux comm name `microsoft-edge` (15 characters).

## Goals / Non-Goals

**Goals:**

- List Edge, Brave, Helium, and Vivaldi when their executable is on `PATH`, on any distribution that installs those names.
- Let Automatic follow the Edge and Brave desktop entries that do not match the executable name.
- Treat `microsoft-edge` as a managed Chromium process so the app can stop it.

**Non-Goals:**

- Flatpak `com.microsoft.Edge`, Snap commands that are not these executable names, Opera, and WSL (WSL uses the Windows browser search).
- A separate profile per Chromium brand. Linux keeps the one managed Chromium profile.
- Changing macOS discovery. Those browsers are already listed there.

## Decisions

1. Append the names after the existing Chrome and Chromium names, in the macOS order: Edge, Brave, Helium, Vivaldi. Chrome stays preferred when it is installed. Names: `microsoft-edge`, `microsoft-edge-stable`, `microsoft-edge-beta`, `microsoft-edge-dev`, `brave`, `brave-browser`, `brave-browser-stable`, `brave-browser-beta`, `brave-browser-nightly`, `helium`, `vivaldi`, `vivaldi-stable`, `vivaldi-snapshot`.
2. Alias only the two mismatched desktop stems. `microsoft-edge` matches the first installed Edge name in that order. `brave-browser` matches the first installed Brave name. Beta, Dev, Nightly, and `vivaldi-stable` already share their stem with the executable.
3. Skip a later `PATH` hit that canonicalises to a path already listed, so a symlink and its target are one row. If canonicalise fails, keep the path.
4. Add the prefix `microsoft-edge` to `is_chrome_image`. That covers `microsoft-edge-stable` as well.

## Risks / Trade-offs

- Two different Edge channels that are both on `PATH` and are not the same file both appear. That is the same as listing Chrome and Chromium today.
- Helium's Linux package name is assumed to be `helium`. If a build uses another name it will not show up until that name is added.

## Migration Plan

No stored choice changes. An existing Automatic choice starts using Edge or Brave only when that browser is the desktop default. Rollback is removing the names.

## Open Questions

None.
