automationScriptsDir=$1
brewfileName=$2

cd $automationScriptsDir

echo "
--------------------------------------------

Pulling latest version from origin"
git pull

echo "
--------------------------------------------

Executing 'cp -r ".zshrc" ~/'"
cp -r ".zshrc" ~/

echo "
--------------------------------------------

Executing 'cp -r ".zprofile" ~/'"
cp -r ".zprofile" ~/

echo "
--------------------------------------------

Executing 'brew update'"
brew update

echo "
--------------------------------------------

Executing 'brew bundle cleanup --force --file $brewfileName"
brew bundle cleanup --force --file $brewfileName

echo "
--------------------------------------------

Executing 'brew bundle install --file $brewfileName"
brew bundle install --file $brewfileName

echo "
--------------------------------------------

Executing 'import-defaults.sh'"
sh "import-defaults.sh"

echo "
--------------------------------------------

Finding outdated formulaes and apps"

brew outdated --casks --greedy; brew outdated --formulae; mas outdated

echo "
--------------------------------------------"
clear