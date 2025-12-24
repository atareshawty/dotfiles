export BASH_SILENCE_DEPRECATION_WARNING=1
eval "$(/opt/homebrew/bin/brew shellenv)"

# https://github.com/Schniz/fnm?tab=readme-ov-file#shell-setup
if command -v fnm 2>&1 >/dev/null; then
	eval "$(fnm env)"
fi

# Atleast uv puts executables here
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/src/useful-snippets"

if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
