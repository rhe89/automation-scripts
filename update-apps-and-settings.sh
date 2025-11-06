#!/bin/zsh
brewfileName=$1

echo "
--------------------------------------------

Pulling latest version from origin"

# git config --global --add safe.directory /Users/roar/code/automation-scripts
# git pull

echo "
--------------------------------------------

Copying .zshrc to Home-folder"

cp -r .zshrc ~/

echo "
--------------------------------------------

Copying .zprofile to Home-folder"

cp -r .zprofile ~/

echo "
--------------------------------------------

Executing 'brew update'"

brew update

echo "
--------------------------------------------

Uninstalling formulaes, casks and App Store Apps that are no longer present in Brewfile"

brew bundle cleanup --force --file $brewfileName

echo "
--------------------------------------------

Installing new formulaes, casks and App Store apps from brewfile"

brew bundle install --file $brewfileName --no-upgrade

echo "
--------------------------------------------

Updating formulaes"

brew upgrade --formula

echo "
--------------------------------------------

Updating App Store apps"

mas upgrade

echo "
--------------------------------------------

Importing defaults"

sh import-defaults.sh

echo "
--------------------------------------------

Listing outdated casks, might be easier to update these manually"

brew outdated --casks

echo "
--------------------------------------------"

echo "update-apps-and-settings done"