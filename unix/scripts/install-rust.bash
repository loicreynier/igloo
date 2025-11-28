#!/usr/bin/env bash

CARGO_HOME=${CARGO_HOME:-$HOME/.local/opt/cargo}
RUSTUP_HOME=${CARGO_HOME:-$HOME/.local/opt/rustup}
export CARGO_HOME RUSTUP_HOME

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
