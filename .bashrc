[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# bash-git-prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  # git_prompt_list_themes for available themes
  GIT_PROMPT_THEME="Solarized"
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# rbenv
eval "$(rbenv init -)"

# nodenv
eval "$(nodenv init -)"
NODE_PATH="/usr/local/lib/node_modules"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init -)"
export PATH="/Users/alex/.pyenv/shims:${PATH}"

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

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/src/atareshawty/dotfiles/snippets"

# Herbie stuff
alias eslint="test-eslint"
alias flow="test-flow"
alias ts="test-typescript"
. "$HOME/.cargo/env"
