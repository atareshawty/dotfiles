### Installation

1. Setup git authentication

2.

```bash
mkdir -p ~/src/atareshawty
cd ~/src/atareshawty
git clone https://github.com/atareshawty/dotfiles.git
cd dotfiles
./install.sh
```

3. Install [Amphetamine App](https://apps.apple.com/us/app/amphetamine/id937984704?mt=12) from the App Store (it can't be installed via Brew).

### Periodically

- Update Brew packages

```bash
brew update
brew upgrade
```

- Update Brew Cask packages

```bash
brew upgrade --cask
```

- Recreate Brewfile

```bash
./script/recreate_brewfile.sh
```

### TODO

- [ ] `useful-snippets` directory
