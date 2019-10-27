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

# pyenv
eval "$(pyenv init -)"

# git-completion
source ~/src/atareshawty/dotfiles/vendor/git-completion.bash

# Default Editor
export VISUAL=nvim
export EDITOR="$VISUAL"

# Aliases
alias apb="ansible-playbook"
alias be="bundle exec"
alias cdalex="cd ~/src/atareshawty"
alias cdsrc="cd ~/src"
alias dotfiles="cd ~/src/atareshawty/dotfiles"
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

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:$HOME/src/blais/beancount"
