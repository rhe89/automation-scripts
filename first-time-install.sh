brewfileName=$1
settingsDir=$2

cd $automationScriptsDir

git pull

echo "
--------------------------------------------

Executing 'cp -r ".zshrc" ~/'"
cp -r ".zshrc" ~/
source ~/.zshrc

echo "
--------------------------------------------

Executing 'cp -r ".zprofile" ~/'"
cp -r ".zprofile" ~/
source ~/.zprofile

echo "
--------------------------------------------

Executing 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash'"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

echo "
--------------------------------------------

Executing '[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"'"
[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"  # This loads nvm 

echo "Executing '[ -s "$HOME/.nvm/bash_completion" ] && \. "$HOME/.nvm/bash_completion"'"
[ -s "$HOME/.nvm/bash_completion" ] && \. "$HOME/.nvm/bash_completion"  # This loads nvm bash_completion 

echo "
--------------------------------------------

Executing 'nvm install 22'"
nvm install 22

echo "
--------------------------------------------

Executing 'brew bundle install --file $brewfileName'"
brew bundle install --file $brewfileName

echo "
--------------------------------------------

Executing 'import-defaults.sh'"
sh "import-defaults.sh"

echo "
--------------------------------------------"
clear