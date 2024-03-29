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

# Upgrade bash
brew install bash
# Then run:
#  sudo vim /etc/shells
#  Add /usr/local/bin/bash
#  Run chsh -s /usr/local/bin/bash - set shell for current user
#  Run sudo chsh -s /usr/local/bin/bash - set shell for root
#  tmux kill-server
#  Restart iTerm2

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
brew install --cask caffeine
brew install --cask dropbox
brew install --cask evernote
brew install --cask flux
brew install --cask google-chrome
brew install --cask imageoptim
brew install --cask iterm2
brew install --cask itsycal
brew install --cask hyperswitch
brew install --cask lastpass
brew install --cask slack
brew install --cask spectacle
brew install --cask spotify
brew install --cask the-unarchiver

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
brew install --cask ngrok

# Install Postman (https://www.getpostman.com/)
brew install --cask postman

# Install muzzle (https://muzzleapp.com/)
brew install --cask muzzle

# Install kap (https://github.com/wulkano/kap)
brew install --cask kap

# Install karabiner-elements (https://github.com/tekezo/Karabiner-Elements)
brew install --cask karabiner-elements

# Install Dozer (https://github.com/Mortennn/Dozer)
brew install --cask dozer

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

# Install proselint (https://github.com/amperser/proselint)
brew install proselint

# Install grip (https://github.com/joeyespo/grip) - requiremd for vim-markdown-preview
brew install grip

# Install hugo (https://gohugo.io)
brew install hugo

# Install kube-ps1 (https://github.com/jonmosco/kube-ps1)
brew install kube-ps1

# Install lens (https://github.com/lensapp/lens)
brew install --cask lens

# Install github-markdown-toc (https://github.com/ekalinin/github-markdown-toc.go)
brew install github-markdown-toc

# Install gitup (https://gitup.co/)
brew install --cask gitup

# Install kindle (https://www.amazon.com/gp/digital/fiona/kcp-landing-page)
brew install kindle

# Install delta (https://github.com/dandavison/delta)
brew tap dandavison/delta https://github.com/dandavison/delta
brew install dandavison/delta/git-delta

# Install git-peek (https://github.com/Jarred-Sumner/git-peek)
brew install jarred-sumner/git-peek/git-peek

# Install Stats (https://github.com/exelban/stats)
brew install --cask stats

# Install bluesnooze (https://github.com/odlp/bluesnooze)
brew install bluesnooze

# Install k9s (https://github.com/derailed/k9s)
brew install derailed/k9s/k9s

# Install Fira Code font
brew tap homebrew/cask-fonts
brew install --cask font-fira-code

# Cleanup
brew cleanup
