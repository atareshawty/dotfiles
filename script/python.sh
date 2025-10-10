#!/bin/bash

# deploy_cell probably already sets up python stuff, but none of the package tooling (uv)

# Check for uv:
if ! command -v uv >/dev/null 2>&1; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source ~/.profile
fi

# Install globally expected python tooling
pip install commitizen pre-commit
