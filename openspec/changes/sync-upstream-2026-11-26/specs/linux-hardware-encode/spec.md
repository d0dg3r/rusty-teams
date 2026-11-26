# Spec Delta

## ADDED Requirements

### Requirement: VAAPI packed slice headers include the start code

On Linux, a VAAPI H.264 packed slice header SHALL include its start code so a receiver can decode the stream.

#### Scenario: Packed header is prefixed

- **WHEN** the Linux hardware encoder emits a packed H.264 slice header
- **THEN** the header bytes include the start code in front of the slice data
