check:
  cargo check --target wasm32-unknown-unknown --lib

clippy:
  cargo  clippy --tests

fmt:
    cargo +nightly fmt

test:
  cargo test
