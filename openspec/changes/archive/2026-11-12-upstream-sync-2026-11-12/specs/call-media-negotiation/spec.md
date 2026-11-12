# Spec Delta

## ADDED Requirements

### Requirement: Faster 1:1 connect with prefetched relay
For 1:1 answers the client SHALL avoid waiting on slow TCP/TLS relays when a prefetched relay grant can be reused, so calls connect without stalling on that path.

#### Scenario: Prefetched relay reused
- **WHEN** a 1:1 call answer proceeds and a relay grant was fetched ahead
- **THEN** the connect path reuses that grant instead of blocking on a slow TCP/TLS relay fetch

### Requirement: Fullband Opus request
The client SHALL ask Teams for fullband Opus on the call audio path when that capability is available.

#### Scenario: Fullband Opus offered
- **WHEN** a call negotiates audio with Teams
- **THEN** the client requests fullband Opus rather than only a narrowband default
