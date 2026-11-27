## MODIFIED Requirements

### Requirement: App manages Chrome on a debug port

On Linux the app SHALL start a Teams session browser with a remote debugging port and its own profile under the XDG data folder, keep it headless while signed in, and show the browser window when Teams needs a login. Automatic SHALL use the default browser when that browser is a supported Chromium browser (Google Chrome, Chromium, Microsoft Edge, Brave, Helium, or Vivaldi) or a Firefox-family browser (Firefox, Zen, LibreWolf, or Floorp); otherwise it SHALL use the first such browser that is installed. Settings > General > Teams session browser MUST be able to pick a different supported browser. A supported browser whose executable is on `PATH` MUST appear in that list. Microsoft Edge Stable MUST appear when `microsoft-edge-stable` is on `PATH`, and Automatic MUST select it when the default desktop entry is `microsoft-edge.desktop`. Brave MUST appear when `brave` is on `PATH`, and Automatic MUST select it when the default desktop entry is `brave-browser.desktop`. Firefox-family browsers SHALL use their own profile, separate from the Chromium profile. With `--endpoint` the app MUST attach to an existing browser endpoint instead of starting one. The app MUST NOT claim a finished built-in login that replaces the browser.

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

#### Scenario: Installed Edge appears and Automatic selects it

- **WHEN** `microsoft-edge-stable` is on `PATH` and the default desktop entry is `microsoft-edge.desktop`
- **THEN** Teams session browser lists that Edge executable
- **AND** Automatic uses it

#### Scenario: Installed Brave appears and Automatic selects it

- **WHEN** `brave` is on `PATH` and the default desktop entry is `brave-browser.desktop`
- **THEN** Teams session browser lists that Brave executable
- **AND** Automatic uses it

#### Scenario: External endpoint attaches instead

- **WHEN** the user starts with `--endpoint` pointing at a browser debug URL
- **THEN** the app attaches to that browser and does not start a second managed browser for that session

#### Scenario: Login window shows then returns to background

- **WHEN** Teams requires a sign-in
- **THEN** the managed browser window becomes visible for login
- **AND** after a successful Teams session with MSAL cache it returns to the background
