# Install latest version of neovim for Ubuntu 20.04:
# - Step one: check latest version of neovim
if ! command -v nvim >/dev/null 2>&1 || [[ "$(nvim --version | head -n1 | awk '{print $2}')" != "v0.10.3" ]]; then
    echo "Incorrect neovim version installed. Fixing that..."
    curl -LO https://github.com/neovim/neovim/releases/download/v0.10.3/nvim.appimage
    chmod +x nvim.appimage
    sudo mv nvim.appimage /bin/nvim
    echo "nvim version=$(nvim --version | head -n1 | awk '{print $2}')"
else
    echo "Neovim version 0.10.3 is installed"
fi

echo "Creating symlinks for config files..."
mkdir -p ~/.config
./script/symlinks.sh
echo "Done creating symlinks"

nvim +"PlugInstall --sync" +qa

source ~/.bash_profile
