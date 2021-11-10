# Set dock size
defaults write com.apple.dock tilesize -int 75; killall Dock

# Disable press and hold
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Always show hidden files
defaults write com.apple.finder AppleShowAllFiles YES

# Show Path bar and status bar in finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# opening and closing windows and popovers
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# smooth scrolling
defaults write -g NSScrollAnimationEnabled -bool false

# showing and hiding sheets, resizing preference windows, zooming windows
# float 0 doesn't work
defaults write -g NSWindowResizeTime -float 0.001

# opening and closing Quick Look windows
defaults write -g QLPanelAnimationDuration -float 0

# rubberband scrolling (doesn't affect web views)
defaults write -g NSScrollViewRubberbanding -bool false

# resizing windows before and after showing the version browser
# also disabled by NSWindowResizeTime -float 0.001
defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false

# showing a toolbar or menu bar in full screen
defaults write -g NSToolbarFullScreenAnimationDuration -float 0

# scrolling column views
defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0

# showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0

# showing and hiding Mission Control, command+numbers
defaults write com.apple.dock expose-animation-duration -float 0

# showing and hiding Launchpad
defaults write com.apple.dock springboard-show-duration -float 0
defaults write com.apple.dock springboard-hide-duration -float 0

# changing pages in Launchpad
defaults write com.apple.dock springboard-page-duration -float 0

# at least AnimateInfoPanes
defaults write com.apple.finder DisableAllAnimations -bool true

# sending messages and opening windows for replies
defaults write com.apple.Mail DisableSendAnimations -bool true
defaults write com.apple.Mail DisableReplyAnimations -bool true

# disable dock bouncing
defaults write com.apple.dock no-bouncing -bool TRUE

# Faster key repeat
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)<Paste>

# disable mouse acceleration
defaults write .GlobalPreferences com.apple.mouse.scaling -1
defaults write .GlobalPreferences com.apple.scrollwheel.scaling -1

# autohide dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

killall Dock

cd /Library/Fonts

curl -O https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Regular.ttf
curl -O https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Bold.ttf

# copy over home/end/pg up and down fix
mkdir ~/Library/KeyBindings/
cp ./DefaultKeyBinding.dict ~/Library/Keybindings/

cd -

echo "1. Now change mouse/trackpad settings"
echo "  a. Mouse"
echo "    i. Point & Click: Secondary Click Only + fastest mouse speed"
echo "    ii. More Gestures: All checked"
echo "    iii. Uncheck Scroll direction: Natural"
echo "  b. Trackpad"
echo "    i. Point & Click: All but look up and data detectors"
echo "2. Change caps lock -> escape"
echo "3. Add a hot corner to sleep the display"
echo "4. Night shift and 1 min Do not Disturb"
echo "5. Setup touch id"
echo "6. Show battery percentage in bar"
echo "7. Install vanilla set it up, and have it start on login"
echo "8. Setup iterm, inconsolata 18pt, unlimited scrollback"
echo "9. Add sound icon to menu bar"
echo "10. Edit sublime settings: https://coderwall.com/p/upolqw/fix-sublime-text-home-and-end-key-usage-on-mac-osx"
echo "11. System -> General -> Always show scroll bar"
echo "12. Add Path to finder toolbar"
echo "13. Add Projects/BrandonsProjects/$HOME to Favorites"
echo "14. Chandle computer name via System Preferences -> Sharing -> Computer Name: "
