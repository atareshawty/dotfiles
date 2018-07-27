[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Path stuff
export PATH=$PATH:$HOME/Library/Python/2.7/bin

# Powerline
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /Users/alex/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh

# Default Editor
export VISUAL=nvim
export EDITOR="$VISUAL"

# Aliases
alias vim=nvim
