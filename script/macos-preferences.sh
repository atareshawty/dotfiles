# Dock Settings
defaults write "com.apple.dock" "persistent-apps" -array
defaults write "com.apple.dock" autohide -bool true
defaults write "com.apple.dock" autohide-delay -float 0.1
defaults write "com.apple.dock" no-bouncing -bool TRUE;

# Desktop Widget Settings
defaults delete com.apple.WindowManager DesktopWidgetStates
defaults write com.apple.finder ShowDesktopWidgets -bool false
defaults write com.apple.WindowManager StandardHideWidgets -bool true
killall WindowManager
killall Finder
killall Dock
