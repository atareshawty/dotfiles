defaults write "com.apple.dock" "persistent-apps" -array
defaults write "com.apple.dock" autohide -bool true
defaults write "com.apple.dock" autohide-delay -float 1000
defaults write "com.apple.dock" no-bouncing -bool TRUE; killall Dock

# Install homebrew, if not installed
echo "Checking for homebrew"
if ! test -d /opt/homebrew; then
	echo "Homebrew not installed, installing..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Homebrew already installed, skipping"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

brew bundle install

echo "Checking default shell"
if [[ "$SHELL" != "/opt/homebrew/bin/bash" ]]; then
	echo "Installing bash as default shell..."
	brew list bash || brew install bash
	sudo chsh -s /usr/local/bin/bash "$USER"
else
	echo "Default shell already brew bash, skipping"
fi

echo "Creating symlinks for config files..."
mkdir -p ~/.config
./script/symlinks.sh
echo "Done creating symlinks"

nvim +"PlugInstall --sync" +qa

source ~/.bash_profile
