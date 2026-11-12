# Changelog

## [0.3.0-joe.1] - 2026-11-12

### Added

- Forgejo as source of truth (`devops-geek/rusty-teams`) with push mirror to GitHub.
- Linux release packages: `.deb`, `.rpm`, Arch `.pkg.tar.zst`, Flatpak bundle.
- Forgejo Actions builds for Windows amd64, Windows ARM64, and macOS universal.
- Local share preview window in the meeting chat (and in the mini call window).

### Fixed

- Wayland screen share via xdg-desktop-portal (KDE, GNOME, Hyprland) without the
  «shared source is gone» toast after confirming the desktop dialog.

## [0.3.0] - 2026-11-10

Upstream-aligned baseline on the fork before Forgejo SoT cutover.
