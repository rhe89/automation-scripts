brewfileName=$1

echo "
--------------------------------------------

Pulling latest version from origin"

git pull

echo "
--------------------------------------------

Copying latest .zprofile and .zshrc from Home-folder"

cp -r ~/.zshrc . 
cp -r ~/.zprofile .

echo "
--------------------------------------------

Dumping casks, formulaes and apps to brewfile"

brew bundle dump --force --no-vscode --file $brewfileName

echo "
--------------------------------------------

Exporting macOS defaults"

sh export-defaults.sh

echo "
--------------------------------------------

Commiting and pushing changes to origin"

echo pwd
git add *
git commit -m "Settings exported"
git push

echo "
--------------------------------------------"
