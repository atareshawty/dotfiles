export BASH_SILENCE_DEPRECATION_WARNING=1
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load up https://github.com/pyenv/pyenv
if command -v pyenv 2>&1 >/dev/null; then
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi

# Load up https://github.com/nodenv/nodenv
if command -v nodenv 2>&1 >/dev/null; then
	eval "$(nodenv init -)"
	# Do I need this?
	NODE_PATH="/usr/local/lib/node_modules"
fi

# Load up https://github.com/rbenv/rbenv
if command -v rbenv 2>&1 >/dev/null; then
	eval "$(rbenv init -)"
fi

# https://github.com/junegunn/fzf
if command -v fzf 2>&1 >/dev/null; then
	eval "$(fzf --bash)"
fi


export PATH="$PATH:$HOME/.local/bin"

# Include commands like psql and pg_dump in path: https://stackoverflow.com/a/49689589
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export PATH="$PATH:$HOME/src/useful-snippets"

if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
