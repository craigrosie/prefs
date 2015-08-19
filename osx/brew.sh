# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# pyenv for managing python versions
brew install pyenv
brew install pyenv-virtualenv

# rbenv for managing ruby versions
brew install rbenv
brew install ruby-build

# Install more recent versions of some OSX defaults
brew install vim --override-system-vi
brew install homebrew/dupes/grep

# Install Cask
brew install caskroom/cask/brew-cask

# Tap versions so we can get Sublime3
brew tap caskroom/versions

# Install casks
brew cask install --appdir="/Applications" atom
brew cask install --appdir="/Applications" bettertouchtool
brew cask install --appdir="/Applications" caffeine
brew cask install --appdir="/Applications" dash
brew cask install --appdir="/Applications" dropbox
brew cask install --appdir="/Applications" evernote
brew cask install --appdir="/Applications" flux
brew cask install --appdir="/Applications" google-chrome
brew cask install --appdir="/Applications" haroopad
brew cask install --appdir="/Applications" imageoptim
brew cask install --appdir="/Applications" iterm2
brew cask install --appdir="/Applications" lastpass
brew cask install --appdir="/Applications" pgadmin3
brew cask install --appdir="/Applications" scroll-reverser
brew cask install --appdir="/Applications" skype
brew cask install --appdir="/Applications" slack
brew cask install --appdir="/Applications" sourcetree
brew cask install --appdir="/Applications" spotify
brew cask install --appdir="/Applications" sublime-text3
brew cask install --appdir="/Applications" the-unarchiver

# Install GoTTY (https://github.com/yudai/gotty)
brew tap yudai/gotty
brew install gotty

# Cleanup
brew cleanup
