#!/usr/local/bin/bash

BREW_BASH='/usr/local/bin/bash'

echo "Adding bash installed by brew in /etc/shells"
grep -qxF $BREW_BASH /etc/shells || echo $BREW_BASH | sudo tee -a /etc/shells
chsh -s $BREW_BASH
