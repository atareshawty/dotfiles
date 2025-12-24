# Interactive shells only
[[ $- != *i* ]] && return

# all 3rd party bash completion scripts
# Example: git
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Setup https://github.com/magicmonty/bash-git-prompt
if [ -f "/opt/homebrew/opt/bash-git-prompt/share/gitprompt.sh" ]; then
	__GIT_PROMPT_DIR="/opt/homebrew/opt/bash-git-prompt/share"
	source "/opt/homebrew/opt/bash-git-prompt/share/gitprompt.sh"
fi

# Set Default Editor to neovim
export VISUAL=nvim
export EDITOR="$VISUAL"

# Aliases
alias be="bundle exec"
alias flush-branches="git branch --merged main | grep -v 'main' | xargs git branch -d && git remote prune origin"
alias la="ls -al"
alias ls="ls -GFh"
alias myip="curl -4 icanhazip.com"
alias spec="bundle exec rspec"
alias tf='terraform'
alias vim="nvim"

# Things I want to keep private
if [ -f ~/.bashrc_private ]; then
  source ~/.bashrc_private
fi
