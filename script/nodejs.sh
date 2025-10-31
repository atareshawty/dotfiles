#!/bin/bash

NODE_VERSION=24.10.0

# Check for nvm
if ! command -v nvm >/dev/null 2>&1; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    source ~/.profile
fi

nvm install $NODE_VERSION

# Always default to the latest available node version on a shell
nvm alias default node

npm install -g @github/copilot
