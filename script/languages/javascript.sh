#!/opt/homebrew/bin/bash

if ! command -v fnm 2>&1 >/dev/null; then
  echo "${BASH_SOURCE[0]}: fnm not installed, cannot manage javascript installation" >&2
  exit 0
fi

latest_node_version=$(fnm list-remote --sort desc 2>/dev/null | head -n 1 | tr -d 'v')

# Check if the latest version is already installed
if fnm list | grep -q "$latest_node_version"; then
  echo "${BASH_SOURCE[0]}: Node.js version $latest_node_version is already installed, skipping"
else
  echo "${BASH_SOURCE[0]}: Installing Node.js version $latest_node_version"
  fnm install "$latest_node_version"
fi
