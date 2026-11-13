# Spec Delta

## Purpose

Local camera start in calls and prejoin when the device offers formats but property queries fail.

## ADDED Requirements

### Requirement: Format property failure does not block open

If querying supported camera formats or the running format property fails, the app MUST still open the stream with a raw format (e.g. NV12 or YUYV) or the existing fallback when the device allows it. Only when no fallback open succeeds MUST the app show the user the error.

#### Scenario: Property failed, raw format available

- **WHEN** the user turns the camera on and the format property fails but the device offers a raw format at the desired rate
- **THEN** local camera starts and does not show a fatal format-property stop

#### Scenario: No fallback possible

- **WHEN** neither format list nor fallback open yields a raw format
- **THEN** the camera stays off and the app shows the error clearly
