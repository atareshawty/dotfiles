#!/opt/homebrew/bin/bash

if ! command -v uv 2>&1 >/dev/null; then
  echo "${BASH_SOURCE[0]}: uv not installed, cannot manage python installation" >&2
  exit 0
fi

# Installs latest python by default
uv python install --preview-features python-install-default 2>/dev/null

uv tool install ruff
uv tool install ty
