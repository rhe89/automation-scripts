eval "$(/opt/homebrew/bin/brew shellenv)"

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
  export MY_VARIABLE="some_value"
  echo "$BOOT_TIME" > "$FLAG_FILE"

  sh ~/Library/Mobile\ Documents/com~apple~CloudDocs/Setup/install.sh
  sh ~/Library/Mobile\ Documents/com~apple~CloudDocs/Code/snippets/bash/print_macos_info.sh
fi