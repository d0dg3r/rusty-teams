## ADDED Requirements

### Requirement: User Desktop client in Settings

The calendar account settings SHALL let the user save a Google OAuth client id and client secret, and SHALL show a short guide for creating a Desktop client. A saved pair MUST be used for Connect Google and for token refresh instead of the process environment or the compiled client. Clearing the client id MUST remove the saved pair so Connect falls back.

#### Scenario: Guide names the Desktop client steps

- **WHEN** the user opens calendar account settings
- **THEN** the guide tells them to enable the Calendar API, set the consent screen for the calendar and email scopes, create an OAuth client of type Desktop, and leave the redirect URI unset because the app uses a loopback port

#### Scenario: Saved pair overrides the build

- **WHEN** the user saves a non-empty client id and a non-empty client secret and then chooses Connect Google
- **THEN** sign-in uses that pair
- **AND** does not use a different client compiled into the build

#### Scenario: Empty settings keep one-click Connect

- **WHEN** the user has not saved a client id and secret and runs a release build that includes the project client
- **THEN** Connect Google completes without the user entering a client id
- **AND** no client-id field is required for that path

#### Scenario: Clearing the pair restores the fallback

- **WHEN** the user clears the saved client id
- **THEN** the saved secret is removed
- **AND** the next Connect uses the environment or the compiled client

#### Scenario: Connected account needs a new sign-in

- **WHEN** the user saves a client pair while a Google account is already connected
- **THEN** the app tells the user that existing tokens belong to the previous client and that they need to connect again
- **AND** the existing account stays until the user disconnects or connects again

### Requirement: Google client secret stays in the keyring

The client secret MUST be stored in the OS keyring. It MUST NOT be written to logs, shown again after save, or stored in the calendar account document. The client id MUST be stored as app metadata.

#### Scenario: Secret is not shown again

- **WHEN** the user saves a client secret and opens calendar account settings again
- **THEN** the secret field is empty
- **AND** the secret is not part of the saved calendar account document
