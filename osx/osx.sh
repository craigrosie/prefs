#!/usr/bin/env bash

# Ask for sudo password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `osx.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#############################
# General UI/UX				#
#############################

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults writer NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults writer NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable the "Are you sure you want to open this?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

#############################
# Trackpad/mouse etc		#
#############################

# Enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defualts -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Disable press-and-hold in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Disable auto-correct
defaults write NSGLobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

#############################
# Screen					#
#############################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

#############################
# Finder					#
#############################

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Empty trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

#############################
# Dock/dashboard etc		#
#############################

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

#############################
# Mail						#
#############################

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Disable inline attachments (just show the icon)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true


#############################
# iTerm2					#
#############################

# Don't show the annoying prompt when quitting iTerm2
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

#############################
# Chrome					#
#############################

# Expand the print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

#############################
# Kill affected apps		#
#############################

for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
    "Dock" "Finder" "Google Chrome" "Mail" "Messages" "Safari" "SystemUIServer" \
    "iCal"; do
    killall "${app}" > /dev/null 2>&1
done
echo "Done. Note that some of these changes require a logout/restart of your OS to take effect.  At a minimum, be sure to restart your Terminal."
