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

# Install more recent versions vim
brew install vim

# Tap versions so we can get Sublime3
brew tap caskroom/versions

# Install casks
brew cask install caffeine
brew cask install dropbox
brew cask install evernote
brew cask install flux
brew cask install google-chrome
brew cask install imageoptim
brew cask install iterm2
brew cask install itsycal
brew cask install hyperswitch
brew cask install lastpass
brew cask install slack
brew cask install spectacle
brew cask install spotify
brew cask install the-unarchiver

# Install gcc
brew install gcc

# Install tree
brew install tree

# Install htop
brew install htop-osx

# Install jq for json manipulation
brew install jq

# Install GNU versions of command line tools
brew install coreutils

# Install gnu-sed over mac sed
brew install gnu-sed --with-default-names

# Install diff-so-fancy
brew install diff-so-fancy

# Install graphviz for pyreverse
brew install graphviz

# Install thefuck
brew install thefuck

# Install tig (https://github.com/jonas/tig)
brew install tig

# Install The Silver Search (ag) (https://github.com/ggreer/the_silver_searcher)
brew install the_silver_searcher

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

# Install redis (https://redis.io/)
brew install redis

# Install ctop (https://github.com/bcicen/ctop)
brew install ctop

# Install fd (https://github.com/sharkdp/fd)
brew install fd

# Install gron (https://github.com/tomnomnom/gron)
brew install gron

# Install tmux (https://github.com/tmux/tmux)
brew install tmux

# Install universal ctags (https://github.com/universal-ctags/ctags)
# NOTE: check if this is still valid install mechanism
brew install --HEAD universal-ctags/universal-ctags/universal-ctags

# Install golang (https://golang.org/)
brew install golang

# Install emojify (https://github.com/mrowa44/emojify)
brew install emojify

# Install cmake (https://cmake.org/)
brew install cmake

# Install markdown (https://daringfireball.net/projects/markdown/)
brew install markdown

# Install youtube-dl (https://github.com/rg3/youtube-dl/)
brew install youtube-dl

# Install aws-shell (replacement for saws) (https://github.com/awslabs/aws-shell)
brew install aws-shell

# Install noti (https://github.com/variadico/noti)
brew install noti

# Install tldr (https://github.com/tldr-pages/tldr)
brew install tldr

# Install record (https://github.com/pinard/Recode)
brew install recode

# Install ngrok (https://ngrok.com/)
brew cask install ngrok

# Install Postman (https://www.getpostman.com/)
brew cask install postman

# Install muzzle (https://muzzleapp.com/)
brew cask install muzzle

# Install kap (https://github.com/wulkano/kap)
brew cask install kap

# Install karabiner-elements (https://github.com/tekezo/Karabiner-Elements)
brew cask install karabiner-elements

# Install bat (https://github.com/sharkdp/bat)
brew install bat

# Install zlib (https://zlib.net/) - required for pyenv installs
brew install zlib

# Install cfn-python-lint (https://github.com/aws-cloudformation/cfn-python-lint)
brew install cfn-lint

# Install shellcheck (https://github.com/koalaman/shellcheck)
brew install shellcheck

# Install yamllint (https://github.com/adrienverge/yamllint)
brew install yamllint

# Install hadolint (https://github.com/hadolint/hadolint)
brew install hadolint

# Install Source Code Pro font
brew tap caskroom/fonts
brew cask install font-source-code-pro

# Cleanup
brew cleanup
