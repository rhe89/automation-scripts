automationScriptsDir=$1
brewfileName=$2

echo "#################                  Copying .zshrc from ~/                      #################"
cp -r ~/.zshrc "$automationScriptsDir" 

echo "#################                  Copying .zprofile from ~/                     #################"
cp -r ~/.zprofile "$automationScriptsDir"

echo "#################        Dumping casks, formulaes and apps to $brewfileName         #################"

brew bundle dump --force --no-vscode --file "$automationScriptsDir/$brewfileName"
echo "#################                  Exporting macOS defaults                    #################"
sh "$automationScriptsDir/export-defaults.sh"

git add *
git commit -m "Settings exported"
git push