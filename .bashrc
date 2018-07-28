[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# bash-git-prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# Default Editor
export VISUAL=nvim
export EDITOR="$VISUAL"

# Aliases
alias vim=nvim
alias src="cd ~/src"
