automationScriptsDir=$1
brewfileName=$2

cd $automationScriptsDir

echo "
--------------------------------------------

Pulling latest version from origin"

git pull

echo "
--------------------------------------------

Copying latest .zprofile and .zshrc"

cp -r ~/.zshrc "$automationScriptsDir" 
cp -r ~/.zprofile "$automationScriptsDir"

echo "
--------------------------------------------

Dumping casks, formulaes and apps to $brewfileName"

brew bundle dump --force --no-vscode --file "$automationScriptsDir/$brewfileName"

echo "
--------------------------------------------

Exporting macOS defaults"

sh "$automationScriptsDir/export-defaults.sh"

echo "
--------------------------------------------

Commiting and pushing changes to origin"

git add * &&
git add .* &&
git commit -m "Settings exported" &&
git push

echo "
--------------------------------------------"