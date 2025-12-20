#!/bin/zsh

brewfileName=$1

echo "
--------------------------------------------

Pulling latest version from origin"

git pull

echo "
--------------------------------------------

Copying latest dotfiles from Home-folder"

cp -r ~/.zshrc ../dotfiles 
cp -r ~/.zprofile ../dotfiles
cp -r ~/.npmrc ../dotfiles

echo "
--------------------------------------------

Dumping casks, formulaes and apps to brewfile"

brew bundle dump --force --no-vscode --file ../brewfiles/$brewfileName

echo "
--------------------------------------------

Exporting macOS defaults"

sh export-defaults.sh

echo "
--------------------------------------------

Commiting and pushing changes to origin"

git add *
git commit -m "Settings exported"
git push

echo "
--------------------------------------------"

echo "export-settings done"
