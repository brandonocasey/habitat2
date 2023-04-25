#!/usr/bin/env bash

xcode-select --install
xcodebuild -license accept

if ! type -t brew >/dev/null 2>&1; then
  echo "installing brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Brew installs:"
brew tap homebrew-ffmpeg/ffmpeg
brew install homebrew-ffmpeg/ffmpeg/ffmpeg $(brew options homebrew-ffmpeg/ffmpeg/ffmpeg | grep -vE '\s' | grep -- '--with-' | tr '\n' ' ')

brew bundle

# add bash to shells
if ! grep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells
fi

if ! po -o comm= $$ | grep 'bash'; then
  chsh -s '/usr/local/bin/bash'
fi
