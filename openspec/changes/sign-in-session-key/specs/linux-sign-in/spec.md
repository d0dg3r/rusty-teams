## ADDED Requirements

### Requirement: Background hand-over keeps the encrypted token cache readable

When the managed Chromium browser stops after a Teams sign-in, the app SHALL keep the cache-encryption cookie that the Teams page uses to read its encrypted token cache. The next start of that same profile MUST still be able to open entries that were written before the stop. The app MUST NOT change other session cookies. If saving the cookie does not finish in time, the app SHALL still close the browser and SHALL record that the cookie was not kept.

#### Scenario: Headless hand-over still opens the cache

- **WHEN** the user finishes Microsoft sign-in and the app moves the managed Chromium browser to the background
- **THEN** the next Teams page in that profile can open the encrypted token cache that was written before the move
- **AND** the app does not ask for sign-in again only because the browser process restarted

#### Scenario: Cookie save that runs out of time still closes the browser

- **WHEN** the app is stopping the managed Chromium browser and saving the cache-encryption cookie does not finish in time
- **THEN** the browser still closes
- **AND** the app records that the cookie was not kept

### Requirement: Sign-in finishes only when a token can be used

The app SHALL treat Teams sign-in as finished, and move the managed browser to the background, only when the Teams page reports a still-valid access token, either in the clear or decrypted from an encrypted cache entry. Storage names that merely look like tokens, and decrypted entries without a still-valid access token, MUST NOT finish sign-in. Until that report arrives, the sign-in window SHALL stay visible.

#### Scenario: Valid access token in encrypted cache finishes sign-in

- **WHEN** the Teams page is showing and decrypts an encrypted cache entry containing a still-valid access token
- **THEN** the app may move the managed browser to the background

#### Scenario: Expired encrypted cache leaves the window open

- **WHEN** the Teams page decrypts encrypted cache entries with the persisted cookie, but none of the plain or decrypted entries is a still-valid access token
- **THEN** the managed browser window stays visible
- **AND** the app does not announce that sign-in has finished

#### Scenario: A still-valid plain access token finishes sign-in

- **WHEN** the Teams page is showing and reports a still-valid plain access token and no opened encrypted entry
- **THEN** the app may move the managed browser to the background

#### Scenario: Token-shaped names leave the window open

- **WHEN** the Teams page is showing and its storage names look like tokens, but it reports no still-valid access token
- **THEN** the managed browser window stays visible
- **AND** the app does not announce that sign-in has finished
