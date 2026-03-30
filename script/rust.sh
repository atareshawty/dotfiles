#!/bin/bash

# Install the latest version of Rust via rustup
if ! command -v rustup >/dev/null 2>&1; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Updating Rust..."
    rustup update
fi

# Install/update Jujutsu (jj) from source
echo "Installing latest Jujutsu (jj)..."
cargo install --force jj-cli
