# Spec Delta

## ADDED Requirements

### Requirement: Sign-in progress in splash and banner

While the managed browser is opening, waiting for Microsoft login, finishing, or failing, the app SHALL show matching progress text on the splash (cold start) and on the connection banner (re-auth). The app MUST NOT reopen a login window that is already visible for the same managed session.

#### Scenario: Cold start while Chrome opens

- **WHEN** the user starts the app on macOS and managed Chrome is still opening for Microsoft sign-in
- **THEN** the splash shows an opening or connecting phase in the UI language
- **AND** raw translation keys are not shown as the status text

#### Scenario: Banner while awaiting credentials

- **WHEN** Teams requires sign-in again and the managed Chrome window is visible awaiting credentials
- **THEN** the connection banner shows an awaiting-login phase
- **AND** the app does not spawn a second login window for that session

### Requirement: Short login grace after success

After a successful Teams session with MSAL cache, the managed Chrome window SHALL return to the background after a short grace (about one second on the warm path).

#### Scenario: Warm re-auth returns quickly

- **WHEN** the user completes Microsoft sign-in on an already provisioned profile
- **THEN** the managed Chrome window returns to the background after the short grace
- **AND** the app shell is usable without waiting for a long fixed delay
