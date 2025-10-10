# Install latest version of neovim for Ubuntu 20.04:
if ! command -v nvim >/dev/null 2>&1 || [[ "$(nvim --version | head -n1 | awk '{print $2}')" != "v0.10.3" ]]; then
    echo "Incorrect neovim version installed. Fixing that..."
    curl -LO https://github.com/neovim/neovim/releases/download/v0.10.3/nvim.appimage
    chmod +x nvim.appimage
    sudo mv nvim.appimage /bin/nvim
    echo "nvim version=$(nvim --version | head -n1 | awk '{print $2}')"
else
    echo "Neovim version 0.10.3 is installed"
fi


# Tmux, if it doesn't exist
if ! command -v tmux >/dev/null 2>&1; then
    echo "Installing tmux"
    sudo apt install tmux
    sudo apt remove -y tmux && sudo apt update && sudo apt install -y automake build-essential pkg-config libevent-dev libncurses5-dev bison
    TMPDIR=$(mktemp -d) && curl -L -o "$TMPDIR/tmux-3.5.tar.gz" https://github.com/tmux/tmux/releases/download/3.5/tmux-3.5.tar.gz
    tar -xzf "$TMPDIR/tmux-3.5.tar.gz" -C "$TMPDIR" && cd "$TMPDIR/tmux-3.5" && ./configure && make && sudo make install && tmux -V && rm -rf "$TMPDIR"
fi

sudo apt update && sudo apt install xclip -y


echo "Creating symlinks for config files..."
mkdir -p ~/.config
./script/symlinks.sh
echo "Done creating symlinks"

source ~/.profile
