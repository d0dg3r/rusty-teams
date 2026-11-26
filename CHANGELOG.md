# Changelog

## [0.6.1-joe.6] - 2026-11-26

The macOS package from `0.6.1-joe.5` did not build. This tag has that fix,
and every package is published with a SHA-256 sidecar.

### Fixed

- The macOS host-load probe compiles. `thread_info` takes the flavor as
  `u32`, and a pthread id is an integer.

### Added

- Each release package has a sibling `<name>.sha256`. Check it with
  `sha256sum -c` in the same directory.

## [0.6.1-joe.5] - 2026-11-26

A send limit that arrives before the camera or the share is sending is kept
and applied when that source starts. On macOS the call report records, every
two seconds, the CPU time each thread used, which camera effects are on, and
the thermal state. The lines are labelled `host load`.

### Fixed

- An early camera or share send limit is applied when that source starts
  sending, even if the controller does not repeat it.

### Added

- macOS call reports include a `host load` line every two seconds.

## [0.6.1-joe.4] - 2026-11-26

Upstream pull request 97, still open there: sharing a window on macOS opens
the system window picker. The macOS package is Apple Silicon (arm64) and
needs macOS 14. Its file name is `macos-arm64.zip`.

### Fixed

- On macOS, Share a window opens the ScreenCaptureKit window picker. Cancelling
  it leaves the call connected. Closing the shared window ends the share with
  a notice.

## [0.6.1-joe.3] - 2026-11-26

Upstream `main` through the token-refresh log, plus the sync that landed
after `0.6.1-joe.2`.

### Fixed

- Editing a channel post to add a channel mention saves. Team and tag
  mentions in a channel edit still save.
- A long local write no longer freezes the window. Reads of chats and the
  sidebar keep their own connections.
- An accepted one-to-one call shows the chat button when the ring has no
  thread id. The button opens the chat with that caller.
- A new channel shows under its team, not as a group chat. A message for a
  channel the app does not know yet refreshes the team list (at most once a
  minute).
- "See fewer channels" sits below the channels it revealed.
- Linux hardware H.264 packed slice headers include their start code, so a
  receiver can decode them
  ([#95](https://github.com/danieldaeschle/rusty-teams/pull/95)).
- When Microsoft refuses a token refresh, the log says why
  ([#126](https://github.com/danieldaeschle/rusty-teams/pull/126)).

## [0.6.1-joe.2] - 2026-11-25

### Fixed

- Updates follow the install, as in
  [#86](https://github.com/danieldaeschle/rusty-teams/pull/86) after review.
  Windows still downloads quietly and restarts when idle and not in a call.
  A Linux copy under `~/.local` asks, then downloads and restarts.
  macOS, deb, rpm, AppImage, and a binary that is not that install open the
  release page. Flatpak does not check. `0.6.1-joe.1` had only the release-page
  path.

## [0.6.1-joe.1] - 2026-11-25

Preview of the upstream pull requests marked `status: ready`, on top of 0.6.1.
Upstream has not merged them yet.

### Added

- A one-to-one chat call starts as audio
  ([#101](https://github.com/danieldaeschle/rusty-teams/pull/101)).
- Search resolves people outside the organization, including a completed email
  and a personal Microsoft account
  ([#87](https://github.com/danieldaeschle/rusty-teams/pull/87)).

### Fixed

- On a Wayland session, keyboard and pointer input outside the window counts as
  activity, so presence stays Available while you work in another app
  ([#106](https://github.com/danieldaeschle/rusty-teams/pull/106)).
- Linux sign-in leaves the splash and opens the browser window
  ([#105](https://github.com/danieldaeschle/rusty-teams/pull/105)).
- Ring and meeting cards stay beside the desktop notification
  ([#104](https://github.com/danieldaeschle/rusty-teams/pull/104)).
- When Google rejects a calendar token, the app offers sign-in again
  ([#103](https://github.com/danieldaeschle/rusty-teams/pull/103)).
- The camera list only contains nodes that can capture
  ([#102](https://github.com/danieldaeschle/rusty-teams/pull/102)).
- Guests can attach files in a chat of a guest organization
  ([#76](https://github.com/danieldaeschle/rusty-teams/pull/76)).
- The update switch is labelled as a release notice. The install-kind
  behaviour from the same pull request is in `0.6.1-joe.2`
  ([#86](https://github.com/danieldaeschle/rusty-teams/pull/86)).

## [0.5.0-joe.5] - 2026-11-24

### Changed

- A newer release is a notice that opens the release page in the browser. The app
  no longer downloads a binary or replaces itself. One switch, `updates.enabled`,
  on Windows, Linux, and macOS. Flatpak still updates through the package.
- This build also contains the call work from `0.5.0-joe.1` and `0.5.0-joe.2`
  (Windows device track, headset recovery, hardware H.264, organizer mute,
  720p level, screen-share scale) together with people search from `0.5.0-joe.3`.

## [0.5.0-joe.4] - 2026-11-23

### Fixed

- Linux deb, rpm and Arch packages use `packaging/linux/rusty-teams.desktop`.
  The package build looked for a desktop file under `crates/app/assets/linux`
  that is no longer in the tree, so the Linux release job failed.

## [0.5.0-joe.3] - 2026-11-23

### Added

- Search and the new-chat recipient field find people outside the organization:
  known contacts by name, and anyone else once the email is complete. The row
  shows the email and the organization name.

## [0.5.0-joe.2] - 2026-11-23

### Fixed

- An organizer mute closes the local microphone, and the next toggle clears it.
- Off and music mode no longer restore the classical noise-suppression track. A named microphone matches the listed device name, and a device switch counts only when audio actually starts.
- An H.264 answer at level 3.0 with 720p limits is raised to level 3.1, so the 720p layer can encode.
- Screen share scales the frame to the 1080p budget before the I420 conversion.
- Linux and macOS notice a headset that appears or disappears during a call.

## [0.5.0-joe.1] - 2026-11-23

### Changed

- Forgejo `main` includes upstream 0.5.0 (`8a5c5082`).
- Windows calls use the platform microphone track for Auto and Low, recover a headset that drops and returns mid-call, send YUY2 cameras, prefer hardware H.264 with a software fallback, and keep the small GPU blur model on battery.

## [0.4.0-joe.23] - 2026-11-16

### Added

- CalDAV calendar accounts (Nextcloud, Fastmail, iCloud, and generic servers) with
  app-password auth in the OS keyring, discovery, read/write, series expansion,
  and RSVP where the server supports scheduling (ADR 0019).
- Read-only ICS subscriptions on the shared iCalendar parser.
- Settings split: **Calendar** (view prefs) and **Calendar accounts** (sources,
  home, write). CalDAV/ICS connect forms stay collapsed until add; long fields
  use stacked labels so titles stay readable.

### Changed

- Calendar merge prefers Outlook, then the home calendar, then the first source.
- Dual-write copy is source-neutral when home is not Outlook.

## [0.4.0-joe.22] - 2026-11-16

### Fixed

- Flatpak `build-bundle` requests branch `stable` (matches `--default-branch`
  / manifest `branch`) instead of implicit `master`.

## [0.4.0-joe.21] - 2026-11-16

### Fixed

- Flatpak tray permission uses `--own-name=org.kde.*` (flatpak only allows
  `.*` wildcards; `StatusNotifierItem-*` is rejected at finish).

## [0.4.0-joe.20] - 2026-11-16

### Fixed

- Flatpak finish-args use `--filesystem=xdg-run/pipewire-0` instead of the
  non-existent `--socket=pipewire` (matches Flathub OBS/Discord).

## [0.4.0-joe.19] - 2026-11-16

### Fixed

- Flatpak webrtc extract uses `bsdtar --no-same-owner` so PPA bubblewrap no
  longer fails chowning zip members to uid 1001 in the build namespace.

## [0.4.0-joe.18] - 2026-11-16

### Fixed

- Flatpak CI installs `ppa:flatpak/stable` (flatpak 1.18) so export accepts
  `--socket=pipewire`; nested `org.flatpak.Builder` cannot run under act
  without D-Bus.

## [0.4.0-joe.17] - 2026-11-16

### Fixed

- Flatpak builds through Flathub `org.flatpak.Builder` so Jammy host flatpak
  1.12 no longer rejects `--socket=pipewire` at export; permanent finish
  errors are not retried.

## [0.4.0-joe.16] - 2026-11-16

### Fixed

- Flatpak manifest sets `appstream-compose: false` so Jammy flatpak-builder
  does not run `appstream-compose` under bwrap (act/Docker: `execvp` miss).
  Metainfo stays in the app and is validated with host `appstreamcli`.

## [0.4.0-joe.15] - 2026-11-16

### Fixed

- Flatpak CI installs `appstream-util` so `appstream-compose` exists when
  flatpak-builder finishes the build (Jammy previously failed with
  `execvp appstream-compose: No such file or directory`).

## [0.4.0-joe.14] - 2026-11-16

### Fixed

- Flatpak SDK build: clear `CFLAGS`/`CXXFLAGS` so Freedesktop `-O2` does not
  override `aws-lc-sys` jitterentropy's required `-O0`.

## [0.4.0-joe.13] - 2026-11-16

### Fixed

- CI retries rustup install/update and PyPI `pip install --no-cache-dir` on
  transient CDN / corrupted-wheel failures that aborted Flatpak and Linux Test.

## [0.4.0-joe.12] - 2026-11-16

### Fixed

- Flatpak build retries `flatpak-builder` up to three times on transient crates.io
  / GnuTLS download failures.
- Linux Test and package builds cap Cargo parallelism (`-j2`) to avoid clang-21
  linker Bus errors on the 16 GiB runners.

## [0.4.0-joe.11] - 2026-11-16

### Fixed

- Flatpak CI installs `elfutils` (`eu-strip`) so flatpak-builder can strip zypak
  debuginfo after the module build.
- Linux Test/Release use `ubuntu-latest` again so any of `ci-runner-linux-01..03`
  (all 16 GiB) can take the job.

## [0.4.0-joe.10] - 2026-11-16

### Fixed

- Flatpak build: allow Git `file://` for zypak's `nickle` submodule clone from
  the flatpak-builder local cache (Git ≥ 2.38).
- CI blur mask-age unit test: lengthen the slow segmenter delay so fast macOS
  runners no longer flake with «mask came back before the model was done».
- Linux Test and Release (packages/Flatpak) temporarily pinned to `px03`
  (16 GiB) while other runners were still at 8 GiB.

## [0.4.0-joe.9] - 2026-11-16

### Fixed

- Flatpak CI on Ubuntu 22.04: install modern `tomlkit` for the cargo generator,
  and build without `flatpak-builder --env` (Jammy 1.2.x). AppStream release
  metadata is written on the host; Google OAuth env is injected only into a
  temporary manifest copy for `option_env!`.

## [0.4.0-joe.7] - 2026-11-16

### Added

- Linux Flatpak release asset built on Forgejo (`packaging/flatpak/`): Freedesktop
  SDK 25.08 build, Google Chrome as Flatpak extra-data via zypak, AppStream
  metainfo, and sandbox defaults for calls, tray, toasts, and screen share.
- Under `FLATPAK_ID`, the app skips XDG self-install and GitHub self-update;
  notification and tray desktop-entry identity use the Flatpak app id.

### Changed

- Forgejo Release (Linux) runs Flatpak in a dedicated job that publishes the
  `.flatpak` bundle; a missing bundle fails that job (no best-effort skip).

## [0.4.0-joe.6] - 2026-11-15

### Added

- OpenSpec archive `macos-prod-foundation` (sign-in forks, ScreenCaptureKit
  picker keep-alive, tray, Notification Center). CI OpenSpec gate:
  `scripts/check-openspec-gate.sh` fails Test when product crates change
  without an `openspec/` touch.
- macOS menu-bar tray (shared `tray-icon` path with Windows) and close to tray
  via the Linux reopen path.
- macOS Notification Center toasts (ADR 0017), same policy as Linux desktop
  notifications.
- Forgejo `macos-arm64` cargo test job; live checklist in `docs/macos-smoke.md`.
- Optional Developer ID codesign / notarize in `scripts/build-macos.sh`; bare
  `*-macos-universal` Mach-O release asset for in-app self-update from a `.app`.

### Fixed

- macOS screen share: ScreenCaptureKit picker no longer closes immediately
  (upstream #47).
- macOS sign-in without Google Chrome: Edge, Brave, Helium, Vivaldi; Chromium
  major from fork `--version` lines (upstream #45).
- Stay-awake on Linux fails the spawn when `PR_SET_PDEATHSIG` cannot be armed.

## [0.4.0-joe.5] - 2026-11-15

### Added

- Linux and macOS noise suppression Auto runs DeepFilterNet plus a speech gate
  on the Pulse/CoreAudio capture hook, so background noise stays quiet without
  leaving the device track. Live-tested in a call.

### Fixed

- A failed Google token refresh is a calendar load error with retry, not an
  empty week. Local Linux installs refuse a release build that is missing the
  Desktop client secret.


## [0.4.0-joe.4] - 2026-11-15

### Added

- Agent rule: every observable behaviour change starts as an OpenSpec change
  before code, smoke, or Roadmap Done (`openspec-first`, `AGENTS.md`).
- Research note for Teams meeting-reminder push («event 128»): unproven in
  captures; Graph `reminderView` polling stays the reminder source of truth.

### Changed

- OpenSpec `calendar-accounts`: Upcoming-list RSVP requirements; reminder push
  only when research proves the Teams event (poll remains the fallback).
- Changelog for 0.4.0-joe.3 now documents the call mixer, hangup, and Auto 720p
  work that shipped in that tag.

## [0.4.0-joe.3] - 2026-11-15

### Added

- Calendar like Teams: default view setting (Last used by default, survives a
  restart), first day of week from the mailbox language, work days and hours
  read from and saved to the Outlook mailbox, time scale 15/30/60 min, and
  this or next week on a day off.
- Calendar grid: day number over the weekday name, work-hour shading, now line
  across the week, title and organizer on one line, series icon, calendar
  colours; a range without today opens at work start.
- Calendar list pane: mini month, Add calendar, collapsible groups with a group
  check box, Show all.
- Linux: desktop toasts via freedesktop Notifications (message, ring, meeting
  reminder) with the same actions as the Windows card.
- Linux: tray icon with the Teams presence menu, close to tray, self-install
  and updates.

### Fixed

- Calendar weeks stayed empty when the calling engine was not ready; the grid
  now loads through the sign-in session, refreshes on the calendar poll, shows
  loading and a Retry notice per failed source.
- A calendar toggle made during a running fetch is no longer undone.
- Calls: mixer leg switch handles `call/mediaAcknowledgement`, refreshes
  control links, and marks the new peer ready on ICE (no 20 s wait / stale
  406/404 on the ended leg).
- Calls: detaching video senders across a peer switch is null-safe (no SIGSEGV
  in the C++ shim); pending camera/share start is not requeued mid-switch.
- Screen share: folded `x-multi-stream` lines stay `recvonly` in mixer answers
  (no `SdpParsingFailure`); local share upgrades the receive-only line to a
  conference send offer.
- Hangup: turn off camera/share publishing, send `leave` and `DELETE callLeg`
  while peers are still open, then close peers so remote tiles drop immediately.
- Area-sweep fixes across chat, calendar, calls and MCP; PR_SET_PDEATHSIG is
  gated to Linux.
- Local install script also stops `/usr/local/bin/rusty-teams` and clears a
  stale single-instance socket.

### Changed

- Camera quality `Auto` uses a 720p capture ceiling (explicit `1080p` remains);
  camera send prefers `MaintainFramerate` and governs bitrate under sustained
  RTT/loss.
- Calling code split from monolithic `call.rs` into focused modules under
  `call/`.
- Diagnostics the app always wrote stay on; only detailed crate logging is
  opt-in (ADR 0013).
- Calendar, weekday and month names follow the app language (en/de).

## [0.4.0-joe.2] - 2026-11-14

### Added

- Help: opt-in debug logging (default off), ring-rotated diagnostics, and scrubbed
  local support packages.
- Settings: preferred browser for links and Google OAuth.
- Sign-in: splash and banner phases for managed Chrome.
- MCP: `schedule_wakeup` resumes an app-started agent session later.
- Google OAuth client baked into the binary (calendars work without a local
  `.env` bake on release builds).

### Fixed

- Calendar event peek wiring restored after an upstream sync dropped AppShell
  open/render handlers.
- Support-package / diagnostics review fixes (merge ring slot `.2`, scrub peer
  names from call logs, safer paths).

## [0.4.0-joe.1] - 2026-11-13

### Added

- Calendar event peek aligned with Teams: full scrollable agenda, enlarge to a
  Tracking panel with attendees by response, and Google fields (calendar name,
  reminders, source link, Open in Google Calendar, Email guests).
- Local Linux install script always rebuilds with `.env.google.local` and
  refuses a binary without the Google client id; missing id with connected
  Google accounts surfaces a notice instead of an empty week.

### Fixed

- Call ring / end tones on macOS and Linux; Echo test call connection hardening.

### Changed

- Islands UI look bound for agents (`docs/design/islands/SPEC.md`, `ui-spec` rule).

## [0.3.0-joe.10] - 2026-11-13

### Changed

- Synced upstream `danieldaeschle/rusty-teams` after merge of Joe PRs #11–#22
  (Linux Chrome/emoji/Pulse, calendar scroll, Wayland/macOS share, Google Calendar,
  agents, camera, UI locale). Fork SoT kept: Forgejo CI/packaging, OpenSpec, changelog.


## [0.3.0-joe.9] - 2026-11-12

### Fixed

- macOS and Wayland share menu: «Share entire screen» and «Share a window» open
  the system picker instead of showing «No windows found» on an empty list.

## [0.3.0-joe.8] - 2026-11-12

### Fixed

- macOS release build links the `browser` crate, so managed Chrome sign-in compiles
  on the macOS runner (`v0.3.0-joe.7` failed with an unresolved `browser` crate).

## [0.3.0-joe.7] - 2026-11-12

### Added

- macOS managed Chrome sign-in: starts Chrome/Chromium on debug port 9222 with a
  profile under Application Support, shows the window for login, then returns to
  headless (same path as Linux); `--endpoint` still attaches to an external Chrome.
- macOS screen share uses the ScreenCaptureKit system dialog (no empty source list).

### Changed

- Non-Windows mic Auto/Low remain on the ADM device track (Pulse / CoreAudio);
  OpenSpec baseline covers `macos-sign-in`, `macos-call-audio`, and screen-share
  on macOS.

## [0.3.0-joe.6] - 2026-11-12

### Added

- Synced upstream `danieldaeschle/rusty-teams` (through `b07109f`): dedicated
  call/meeting window, Teams-like call toolbar and gallery paging, join preview,
  splash with loading progress, native Manage team page, out-of-office notice,
  chat message appear animations and in-chat typing indicator.
- MCP: write_message / add_reaction with review-before-send, free-time lookup and
  meeting organization; meeting proposals persist across restart
  (store migrations `0030`, `0031`).

### Changed

- Workspace version aligned to `0.3.0` with upstream; Joe release tags remain
  `v0.3.0-joe.N`.
- Fork features kept across the merge: UI locale DE/EN, camera quality Auto/720p/1080p,
  Wayland ScreenCast portal, Google calendar accounts, agent providers, Forgejo
  CI/packaging, and the bundled CBDT emoji font.

## [0.3.0-joe.5] - 2026-11-12

### Added

- UI language: English and German (Germany), with OS locale on first start
  (`de*` → German, otherwise English) and a persisted override under Appearance.
- `rust-i18n` catalog for app chrome, settings, calls notices, tray, and agents;
  missing keys fall back to English.

### Changed

- Call notices use stable i18n keys (optional detail payload) and are localized
  at the UI boundary instead of shipping English literals from calling.

## [0.3.0-joe.4] - 2026-11-12

### Fixed

- Camera capture prefers MJPEG 1080p/720p at 30 fps on USB 2.0 webcams (e.g. C930e)
  instead of falling back to YUYV 1080p at 5 fps; opens under 30 fps are rejected
  when a faster format exists.
- MJPEG frames decode locally (zune-jpeg → I420) with reusable buffers.
- UVC best-effort: disable exposure dynamic framerate and set 50 Hz power-line
  frequency; call reports log the chosen format plus capture fps / decode time.

## [0.3.0-joe.3] - 2026-11-12

### Fixed

- 1:1 escalation answers no longer emit an extra folded gallery m-line (`mid 3-0`),
  which triggered Teams `InvalidNumberOfMedia` / «Incorrect number of media».
- Same-peer renegotiation keeps a short grace after the answer timeout so a late
  camera answer (`recvonly`) can still be applied instead of rolling back send.
- Camera open survives UVC `CameraFormat` property failures (Closest NV12 first;
  AbsoluteHighest only as last resort).

## [0.3.0-joe.2] - 2026-11-12

### Added

- Camera video quality setting: Auto, 720p, or 1080p (no 4K), in call and prejoin
  camera menus; choice persists and applies to capture plus stage receive limits.

### Changed

- Auto / 1080p prefer 1080p capture and advertise matching send capabilities;
  stage receive uses 1080p-class budgets when allowed.
- CI tests run on Forgejo only; GitHub Actions are mirror stubs.

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
