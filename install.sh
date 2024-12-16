# Install homebrew, if not installed
echo "Checking for homebrew"
if ! command -v brew 2>&1 >/dev/null; then
	echo "Homebrew not installed, installing..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Homebrew already installed, skipping"
fi

brew bundle install

echo "Checking default shell"
if [[ "$SHELL" != "/opt/homebrew/bin/bash" ]]; then
	echo "Installing bash as default shell..."
	brew list bash || brew install bash
	chsh -s /opt/homebrew/bin/bash
else
	echo "Default shell already brew bash, skipping"
fi

echo "Creating symlinks for config files..."
mkdir -p ~/.config
./script/symlinks.sh
echo "Done creating symlinks"

nvim +"PlugInstall --sync" +qa

source ~/.bash_profile
