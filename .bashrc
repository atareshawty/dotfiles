[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# bash-git-prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# rbenv
eval "$(rbenv init -)"

# nodenv
eval "$(nodenv init -)"
NODE_PATH="/usr/local/lib/node_modules"

# Default Editor
export VISUAL=nvim
export EDITOR="$VISUAL"

# Aliases
alias be="bundle exec"
alias cdalex="cd ~/src/atareshawty"
alias cdsrc="cd ~/src"
alias myip="curl -4 icanhazip.com"
alias spec="bundle exec rspec"
alias vim=nvim
