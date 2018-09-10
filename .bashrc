[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# bash-git-prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# rbenv
eval "$(rbenv init -)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Default Editor
export VISUAL=nvim
export EDITOR="$VISUAL"

# Aliases
alias be="bundle exec"
alias cdalex="cd ~/src/atareshawty"
alias cdsrc="cd ~/src"
alias spec="bundle exec rspec"
alias vim=nvim
