#!/bin/zsh

brewfileName=$1
settingsDir=$2

cd $automationScriptsDir

echo "
--------------------------------------------

Pulling latest version from origin"

git pull

echo "
--------------------------------------------

Copying .zshrc to Home-folder"

cp -r ".zshrc" ~/
source ~/.zshrc

echo "
--------------------------------------------

Copying .zprofile to Home-folder"

cp -r ".zprofile" ~/
source ~/.zprofile

echo "
--------------------------------------------

Installing nvm"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

echo "
--------------------------------------------

Configuring nvm"

[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"  # This loads nvm 

echo "Executing '[ -s "$HOME/.nvm/bash_completion" ] && \. "$HOME/.nvm/bash_completion"'"

[ -s "$HOME/.nvm/bash_completion" ] && \. "$HOME/.nvm/bash_completion"  # This loads nvm bash_completion 

echo "
--------------------------------------------

Installing node v22"

nvm install 22

echo "
--------------------------------------------

Installing new formulaes, casks and App Store apps from brewfile"

brew bundle install --file $brewfileName

echo "
--------------------------------------------

Importing defaults"

sh "import-defaults.sh"

echo "
--------------------------------------------"

echo "first-time-install done"