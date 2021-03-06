#!/bin/bash

ln -sfn ~/src/atareshawty/dotfiles/nvim ~/.config/nvim
ln -sfn ~/src/atareshawty/dotfiles/.gitconfig ~/.gitconfig
ln -sfn ~/src/atareshawty/dotfiles/tmux.conf ~/.tmux.conf
ln -sfn ~/src/atareshawty/dotfiles/.profile ~/.profile
ln -sfn ~/src/atareshawty/dotfiles/.bashrc ~/.bashrc
ln -sfn ~/src/atareshawty/vendor/git-completion.bash ~/git-completion.bash
ln -sfn ~/src/atareshawty/shells /etc/shells

# linter rules
ln -sfn ~/src/atareshawty/dotfiles/linter_rules/rubocop.yaml ~/.rubocop.yml
ln -sfn ~/src/atareshawty/dotfiles/linter_rules/eslintrc.json ~/.eslintrc.json
