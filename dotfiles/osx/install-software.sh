#!/usr/bin/bash

brew tap homebrew-ffmpeg/ffmpeg
brew install homebrew-ffmpeg/ffmpeg/ffmpeg $(brew options homebrew-ffmpeg/ffmpeg/ffmpeg | grep -vE '\s' | grep -- '--with-' | tr '\n' ' ')

brew bundle

echo "Set Spectacle Upper Left to cmd-alt-1"
echo "Set Spectacle Upper Right to cmd-alt-2"
echo "Set Spectacle Lower Left to cmd-alt-3"
echo "Set Spectacle Lower Right to cmd-alt-4"
echo "Download https://github.com/noah-nuebling/mac-mouse-fix"
echo "add /usr/local/bin/bash to /etc/shells"
echo "chsh -s /usr/local/bin/bash"
