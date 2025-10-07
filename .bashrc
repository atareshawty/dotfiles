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

export PATH="$PATH:$HOME/.local/bin"

# Things I want to keep private
if [ -f ~/.bashrc_private ]; then
  source ~/.bashrc_private
fi
