eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="/usr/local/bin:$PATH"

export PATH="$PATH:$HOME/.dotnet/tools"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# File to track last set time
FLAG_FILE="$HOME/.first_zsh_session_flag"

# Get system boot time
BOOT_TIME=$(sysctl -n kern.boottime | awk -F'[ ,}]+' '{print $4}')

# Get saved boot time from flag file, if it exists
if [[ -f "$FLAG_FILE" ]]; then
  LAST_BOOT=$(cat "$FLAG_FILE")
else
  LAST_BOOT=0
fi

# Compare boot times: if different, it's a new startup
if [[ "$BOOT_TIME" -ne "$LAST_BOOT" ]]; then
  # First terminal session after boot/wake
  echo "$BOOT_TIME" > "$FLAG_FILE"

  sh ~/code/automation-scripts/print-macos-info.sh
fi
