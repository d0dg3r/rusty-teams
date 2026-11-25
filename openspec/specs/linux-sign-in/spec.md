# linux-sign-in Specification

## Purpose

On Linux the app starts and manages Chrome/Chromium with remote debugging (dedicated profile folder), signs in to the Microsoft account through it, starts from the local cache, and keeps exactly one running instance.

## Requirements

### Requirement: App manages Chrome on a debug port

On Linux the app SHALL start a Teams session browser with a remote debugging port and its own profile under the XDG data folder, keep it headless while signed in, and show the browser window when Teams needs a login. Automatic SHALL use the default browser when that browser is Chromium-based (Chrome, Chromium) or Firefox-family (Firefox, Zen, LibreWolf, Floorp); otherwise it SHALL use the first such browser that is installed. Settings > General > Teams session browser MUST be able to pick a different supported browser. Firefox-family browsers SHALL use their own profile, separate from the Chromium profile. With `--endpoint` the app MUST attach to an existing browser endpoint instead of starting one. The app MUST NOT claim a finished built-in login that replaces the browser.

#### Scenario: Default start launches managed Chrome

- **WHEN** the user starts the app on Linux without `--endpoint` and the default browser is Chrome or Chromium
- **THEN** the app starts that browser on the debug port with the managed Chromium profile
- **AND** can open Teams sessions through that instance

#### Scenario: Default Firefox-family browser launches managed

- **WHEN** the user starts the app on Linux without `--endpoint` and the default browser is Firefox, Zen, LibreWolf, or Floorp
- **THEN** the app starts that browser with the Firefox-family profile
- **AND** does not reuse the Chromium profile

#### Scenario: Settings picks another browser

- **WHEN** the user sets Teams session browser to a different supported browser
- **THEN** the next start uses that browser instead of the automatic choice

#### Scenario: External endpoint attaches instead

- **WHEN** the user starts with `--endpoint` pointing at a browser debug URL
- **THEN** the app attaches to that browser and does not start a second managed browser for that session

#### Scenario: Login window shows then returns to background

- **WHEN** Teams requires a sign-in
- **THEN** the managed browser window becomes visible for login
- **AND** after a successful Teams session with MSAL cache it returns to the background

### Requirement: Start from local cache

The app SHALL open from its local cache without blocking the first paint on a full network round-trip for the sidebar.

#### Scenario: Cached chats appear without a spinner wall

- **WHEN** the user has used the app before and starts it again
- **THEN** cached chats and channels are shown from the local store while the session reconnects

### Requirement: Sign-in progress in splash and banner

While the managed browser is opening, waiting for Microsoft login, finishing, or failing, the app SHALL show matching progress text on the splash (cold start) and on the connection banner (re-auth). The app MUST NOT reopen a login window that is already visible for the same managed session.

#### Scenario: Cold start while Chrome opens

- **WHEN** the user starts the app on Linux and managed Chrome is still opening for Microsoft sign-in
- **THEN** the splash shows an opening or connecting phase in the UI language
- **AND** raw translation keys are not shown as the status text

#### Scenario: Banner while awaiting credentials

- **WHEN** Teams requires sign-in again and the managed Chrome window is visible awaiting credentials
- **THEN** the connection banner shows an awaiting-login phase
- **AND** the app does not spawn a second login window for that session

#### Scenario: Failed browser start

- **WHEN** managed Chrome cannot be started or attached for sign-in
- **THEN** the splash or banner shows a failed phase with a short actionable message

### Requirement: Short login grace after success

After a successful Teams session with MSAL cache, the managed Chrome window SHALL return to the background after a short grace (about one second on the warm path), not a multi-second wait meant only for first-time login.

#### Scenario: Warm re-auth returns quickly

- **WHEN** the user completes Microsoft sign-in on an already provisioned profile
- **THEN** the managed Chrome window returns to the background after the short grace
- **AND** the app shell is usable without waiting for a long fixed delay

### Requirement: Managed Chrome uses system fonts

On Linux the managed Chrome process MUST NOT inherit the app’s private FONTCONFIG settings. Microsoft login pages MUST render with the browser’s normal system fonts.

#### Scenario: Microsoft login without app UI fonts

- **WHEN** managed Chrome shows the Microsoft sign-in page
- **THEN** the page does not use the app’s custom UI font family from FONTCONFIG
- **AND** emoji and system fonts still resolve through Chrome’s normal font path

### Requirement: Single instance

A second start SHALL bring the existing window to the front instead of opening a second app process for everyday use.

#### Scenario: Second launch focuses the first window

- **WHEN** the app is already running and the user launches it again
- **THEN** the existing window is raised
- **AND** a second full client does not stay in the foreground as a duplicate

### Requirement: Flatpak finds packaged Chrome by name

On Linux, when the app runs as Flatpak and no `--endpoint` is given, the managed browser search MUST resolve `google-chrome` from the sandbox PATH (the packaged wrapper) before failing. The app MUST NOT require host PATH or host filesystem mounts for that discovery.

#### Scenario: Sandbox PATH provides google-chrome

- **WHEN** the Flatpak starts without `--endpoint` and `google-chrome` is on the sandbox PATH
- **THEN** the app starts that browser on the debug port with the managed profile under the Flatpak XDG data folder
- **AND** sign-in proceeds without asking the user to grant host filesystem access

### Requirement: Headless browser does not hold the opening splash

When the managed browser is already running in the background, the app SHALL leave the opening-browser splash. Cached chats and channels MUST become visible. The opening splash SHALL stay only while the browser is actually opening, while a login window is visible, while sign-in is finishing, or when the browser failed to start.

#### Scenario: Existing headless session shows the cache

- **WHEN** the user starts the app and the managed browser is already running headless with the Teams profile
- **THEN** the opening-browser splash ends
- **AND** cached chats and channels are shown

#### Scenario: Visible login window still blocks the shell

- **WHEN** the managed browser window is visible and waiting for Microsoft sign-in
- **THEN** the splash stays on the awaiting-sign-in phase until that window finishes or the start fails

### Requirement: Missing token opens the sign-in window

When Teams needs a sign-in and the managed browser window is not visible, the app SHALL open that window for Microsoft sign-in. The app MUST NOT open a second window while one is already visible for that session. Closing the window MUST NOT immediately open another one. The sign-in banner SHALL offer a Sign in action that opens the window when none is visible.

#### Scenario: Headless session with no token shows the browser

- **WHEN** Teams needs a sign-in and the managed browser is running headless
- **THEN** the managed browser window becomes visible for sign-in
- **AND** a second window is not opened while that one stays visible

#### Scenario: Sign in action opens a closed window

- **WHEN** the sign-in banner is showing and the managed browser window is not visible
- **AND** the user chooses Sign in
- **THEN** the managed browser window opens for sign-in

#### Scenario: Sign in does not duplicate a visible window

- **WHEN** the managed browser window is already visible for sign-in
- **AND** the user chooses Sign in on the banner
- **THEN** the app does not open another browser window
