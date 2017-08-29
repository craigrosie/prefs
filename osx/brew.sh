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

# Advanced bash completion
brew install bash-completion

# pyenv for managing python versions
brew install pyenv
brew install pyenv-virtualenv

# rbenv for managing ruby versions
brew install rbenv
brew install ruby-build

# jenv for managing java versions
brew install jenv

# Install postgres
brew install postgres
# Initialise db
initdb /usr/local/var/postgres -E utf8
# Install AdminPack
psql postgres -c 'CREATE EXTENSION "adminpack";'
# Configure postgres to run on startup
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

# icu4c (https://github.com/Homebrew/homebrew/blob/master/Library/Formula/icu4c.rb) for gem installs
brew install icu4c

# Install more recent versions of some OSX defaults
brew install vim --override-system-vi
brew install homebrew/dupes/grep

# Install Cask
brew install caskroom/cask/brew-cask

# Tap versions so we can get Sublime3
brew tap caskroom/versions

# Install casks
brew cask install --appdir="/Applications" atom
brew cask install --appdir="/Applications" caffeine
brew cask install --appdir="/Applications" dash
brew cask install --appdir="/Applications" dropbox
brew cask install --appdir="/Applications" evernote
brew cask install --appdir="/Applications" flux
brew cask install --appdir="/Applications" google-chrome
brew cask install --appdir="/Applications" haroopad
brew cask install --appdir="/Applications" imageoptim
brew cask install --appdir="/Applications" iterm2
brew cask install --appdir="/Applications" itsycal
brew cask install --appdir="/Applications" hyperswitch
brew cask install --appdir="/Applications" java
brew cask install --appdir="/Applications" lastpass
brew cask install --appdir="/Applications" noizio
brew cask install --appdir="/Applications" p4merge
brew cask install --appdir="/Applications" pgadmin3
brew cask install --appdir="/Applications" scroll-reverser
brew cask install --appdir="/Applications" skitch
brew cask install --appdir="/Applications" skype
brew cask install --appdir="/Applications" slack
brew cask install --appdir="/Applications" sourcetree
brew cask install --appdir="/Applications" spectacle
brew cask install --appdir="/Applications" spotify
brew cask install --appdir="/Applications" sublime-text3
brew cask install --appdir="/Applications" the-unarchiver

# Install gcc
brew install gcc

# Install tree
brew install tree

# Install GoTTY (https://github.com/yudai/gotty)
brew tap yudai/gotty
brew install gotty

# Install htop
brew install htop-osx

# Install jq for json manipulation
brew install jq

# Install GNU versions of command line tools
brew install coreutils

# Install cheat (https://github.com/chrisallenlane/cheat)
brew install cheat

# Install gnu-sed over mac sed
brew install gnu-sed --with-default-names

# Install diff-so-fancy
brew install diff-so-fancy

# Install gs for pdf compression
brew install gs

# Install graphviz for pyreverse
brew install graphviz

# Install thefuck
brew install thefuck

# Install lnav (http://lnav.org/)
brew install lnav

# Install peco (https://github.com/peco/peco)
brew install peco

# Install tig (https://github.com/jonas/tig)
brew install tig

# Install ranger (https://github.com/ranger/ranger)
brew install ranger

# Install The Silver Search (ag) (https://github.com/ggreer/the_silver_searcher)
brew install the_silver_searcher

# Install shpotify (https://github.com/hnarayanan/shpotify)
brew install shpotify

# Install yank (https://github.com/mptre/yank)
brew install yank

# Install fasd (https://github.com/clvv/fasd)
brew install fasd

# Install fzf (https://github.com/junegunn/fzf)
brew install fzf

# Install ncdu (https://dev.yorhel.nl/ncdu)
brew install ncdu

# Install pgcli (https://github.com/dbcli/pgcli)
brew install pgcli

# Install git-standup (https://github.com/kamranahmedse/git-standup)
brew install git-standup

# Install icdiff (http://www.jefftk.com/icdiff)
brew install icdiff

# Install figlet (http://www.figlet.org/)
brew install figlet

# Install grip (https://github.com/joeyespo/grip)
brew install grip

# Install redis (https://redis.io/)
brew install redis

# Install ctop (https://github.com/bcicen/ctop)
brew install ctop

# Install ccat (https://github.com/jingweno/ccat)
brew install ccat

# Install Postman (https://www.getpostman.com/)
brew cask install postman

# Install muzzle (https://muzzleapp.com/)
brew cask install muzzle

# Install kap (https://github.com/wulkano/kap)
brew cask install kap

# Install Source Code Pro font
brew tap caskroom/fonts
brew cask install font-source-code-pro

# Cleanup
brew cleanup
