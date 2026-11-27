## 1. Accept

- [x] 1.1 Bound ICE waiting on the incoming 1:1 answer to the short settle, and leave the full cap for later negotiation
- [x] 1.2 End a connecting call as cancelled when `POST acceptance` returns HTTP 404 because the call does not exist
- [x] 1.3 Unit-test the 404 classification and the short gather budget
- [x] 1.4 `cargo test -p calling --lib call::tests` for the new tests, plus the state-machine cancel test
