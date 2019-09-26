#!/bin/bash

# Install rustup
curl https://sh.rustup.rs -sSf | sh

# Get rust in path
source $HOME/.cargo/env

# Get latest version
rustup update

# Install the formatter
rustup component add rustfmt --toolchain stable-x86_64-apple-darwin
