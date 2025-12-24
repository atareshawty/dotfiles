export BASH_SILENCE_DEPRECATION_WARNING=1
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load up https://github.com/nodenv/nodenv
if command -v nodenv 2>&1 >/dev/null; then
	eval "$(nodenv init -)"
	# Do I need this?
	NODE_PATH="/usr/local/lib/node_modules"
fi

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/src/useful-snippets"

if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
