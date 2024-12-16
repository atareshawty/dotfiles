export BASH_SILENCE_DEPRECATION_WARNING=1
eval "$(/opt/homebrew/bin/brew shellenv)"

# all 3rd party bash completion scripts
# Example: git
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Setup https://github.com/magicmonty/bash-git-prompt
if [ -f "/opt/homebrew/opt/bash-git-prompt/share/gitprompt.sh" ]; then
	__GIT_PROMPT_DIR="/opt/homebrew/opt/bash-git-prompt/share"
	source "/opt/homebrew/opt/bash-git-prompt/share/gitprompt.sh"
fi

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

export PATH="$PATH:$HOME/src/useful-snippets"
