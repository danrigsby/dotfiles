#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Ensure that $HOSTNAME is defined
if ! grep -q "$HOSTNAME" "/etc/hosts" ; then
  sudo sh -c 'echo "$HOSTNAME    127.0.0.1" >> /etc/hosts'
fi
 
# Symlink into the normal place
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
 
# Install Homebrew
which -s brew
if [[ $? != 0 ]] ; then
  echo "Installing brew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
# Taps & Updates
echo "Updating brew..."
brew update &>/dev/null
brew tap homebrew/dupes &>/dev/null
brew tap homebrew/boneyard &>/dev/null
brew install homebrew/dupes/grep &>/dev/null

# Upgrade any already-installed formulae.
brew upgrade --all

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
brew tap homebrew/versions
brew install bash-completion2

# Install `wget` with IRI support.
brew install wget --with-iri

# Install RingoJS and Narwhal.
# Note that the order in which these are installed is important;
# see http://git.io/brew-narwhal-ringo.
brew install ringojs
brew install narwhal

# Install more recent versions of some OS X tools.
brew install vim --override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen
brew install homebrew/php/php55 --with-gmp

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install Cask
echo "Checking brew cask..."
brew install caskroom/cask/brew-cask &>/dev/null
brew upgrade brew-cask &>/dev/null
brew tap caskroom/versions &>/dev/null

# Install dependencies
echo "Checking dependencies..."
 
which -s java
if [[ $? != 0 ]]; then
  brew cask install java --force
else
  version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
  echo Java Version $version
  if [[ "$version" < "1.8" ]]; then
    brew cask install java --force
  fi
fi
 
which -s java || brew cask install java
which -s git || brew install git
which -s sbt || brew install sbt
which -s scala || brew install scala
which -s node || brew install node
which -s wget || brew install wget
which -s ack || brew install ack

# Install web/javascript tooling
which -s gulp || npm install gulp -g
which -s grunt || npm install grunt -g
which -s jsxhint || npm install jsxhint -g
which -s eslint || npm install eslint -g

# Change git autocrlf to "input"
git config --global core.autocrlf input

# Install Zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Install mackup and create config file pointing to google drive
brew install mackup
rm .mackup.cfg
printf '%s\n%s' '[storage]' 'engine = google_drive' >> .mackup.cfg

# Instll quick look plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webpquicklook suspicious-package && qlmanage -r

# Install applications
echo "installing applications..."
brew cask install google-chrome
brew cask install google-drive
brew cask install iterm2
brew cask install atom
brew cask install evernote
brew cask install intellij-idea
brew cask install sequel-pro
brew cask install sourcetree
brew cask install virtualbox
brew cask install calibre
brew cask install firefox
brew cask install dashlane
brew cask install fluid
brew cask install vlc
brew cask install xtrafinder
brew cask install flashlight
brew cask install diffmerge
brew cask install openemu
brew cask install slack
brew cask install visual-studio-code
brew cask install spectacle
# brew cask install steam

brew cask install bartender
brew cask install cheatsheet

#Install atom plugin
apm install sublime-style-column-selection
apm install autocomplete-plus
apm install autocomplete-paths
#apm install circle-ci
apm install enhanced-tabs
apm install file-icons
apm install language-scala
apm install minimap
apm install open-recent
apm install react
#apm install terminal-panel
apm install term2
apm install sublime-tabs
apm install git-log
apm install git-go
apm install git-history
apm install git-plus
apm install git-projects
apm install git-tab-status
apm install merge-conflicts
apm install pigments
apm install highlight-selected
apm install project-manager
#apm install editorconfig
apm install highlight-line
apm install regex-railroad-diagram
apm install git-blame
apm install minimap-selection
apm install trailing-spaces
apm install minimap-color-highlight 
apm install minimap-git-diff

# Cleanup
brew cleanup

echo "COMPLETE: Run 'mackup restore' to restore any saved settings"

