### Installation

1. Setup git authentication

2. ```bash
mkdir -p ~/src/atareshawty
cd ~/src/atareshawty
git clone https://github.com/atareshawty/dotfiles.git
./install.sh
```

2. Install [Amphetamine App](https://apps.apple.com/us/app/amphetamine/id937984704?mt=12) from the App Store (it can't be installed via Brew).

### Periodically

1. Update Brew packages

```bash
brew update
brew upgrade
```

1. Update Brew Cask packages

```bash
brew upgrade --cask
```

1. Recreate Brewfile

```bash
./script/recreate_brewfile.sh
```

### TODO

- [ ] Occasionally check in on python code folding to see if Treesitter can do imports
- [ ] `useful-snippets` directory
