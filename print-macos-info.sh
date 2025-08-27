# macOS Uptime & System Info Dashboard on Terminal Launch

format_duration() {
    local seconds=$1
    local mins=$((seconds / 60))
    local hrs=$((mins / 60))
    local days=$((hrs / 24))
    local years=$((days / 365))
    local months=$(((days % 365) / 30))
    days=$((days % 30))
    hrs=$((hrs % 24))
    mins=$((mins % 60))

    local parts=()
    ((years > 0)) && parts+=("$years yr")
    ((months > 0)) && parts+=("$months mo")
    ((days > 0)) && parts+=("$days d")
    ((hrs > 0)) && parts+=("$hrs h")
    ((mins > 0)) && parts+=("$mins min")

    echo "${parts[*]}"
}

update_cached_uptime_info() {
    local cache_file="/tmp/macos_uptime_cache"
    local cache_age=60  # seconds

    if [[ -f "$cache_file" ]] && [[ $(( $(date +%s) - $(stat -f "%m" "$cache_file") )) -lt $cache_age ]]; then
        source "$cache_file"
        return
    fi

    # Update: fetch last wake
    last_wake=$(pmset -g log | grep -i "Wake from" | tail -1 | awk '{$1=$1; print}')
    if [[ -n "$last_wake" ]]; then
        wake_time=$(echo "$last_wake" | awk '{print $1 " " $2}')
        if [[ "$wake_time" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
            wake_ts=$(date -j -f "%Y-%m-%d %H:%M:%S" "$wake_time" +%s 2>/dev/null)
        else
            wake_ts=$(date -j -f "%m/%d/%y %H:%M:%S" "$wake_time" +%s 2>/dev/null)
        fi
    fi

    # Update: fetch last unlock
    last_unlock=$(log show --predicate 'eventMessage contains "system was unlocked"' --last 1h --style syslog 2>/dev/null | grep "system was unlocked" | tail -1 | awk '{print $1 " " $2}')
    if [[ -n "$last_unlock" ]]; then
        unlock_ts=$(date -j -f "%Y-%m-%d %H:%M:%S.%N" "$last_unlock" +%s 2>/dev/null)
    fi

    {
        [[ -n "$wake_ts" ]] && echo "wake_ts=$wake_ts"
        [[ -n "$unlock_ts" ]] && echo "unlock_ts=$unlock_ts"
    } > "$cache_file"
    source "$cache_file"
}

# --- Time since last reboot ---
boot_time=$(sysctl -n kern.boottime | awk -F'[ ,}]+' '{print $4}')
boot_time_human=$(date -jf %s $boot_time +"%Y-%m-%d %H:%M:%S")
boot_seconds=$(( $(date +%s) - boot_time ))
boot_duration=$(format_duration $boot_seconds)

# Time since wake
if [[ -n "$wake_ts" ]]; then
    wake_duration=$(format_duration $(( $(date +%s) - wake_ts )))
else
    wake_duration="N/A"
fi

# Time since unlock
if [[ -n "$unlock_ts" ]]; then
    unlock_duration=$(format_duration $(( $(date +%s) - unlock_ts )))
else
    unlock_duration="N/A"
fi

# --- Display Summary ---
echo ""
echo "🖥️  macOS Uptime Info:"
echo "  • Time since last reboot:  $boot_duration (booted at $boot_time_human)"
echo "  • Time since last wake:    $wake_duration"
echo "  • Time since last unlock:  $unlock_duration"

MAC_IP="mac-mini-bod.local"

echo ""
ping -c 1 -W 1 "$MAC_IP" &> /dev/null
if [ $? -eq 0 ]; then
    echo "Mac Mini in Bod is ON."
else
    echo "Mac Mini in Bod is not responding to ping (might be asleep or off)."
fi

echo ""
echo "🔥 Top 5 CPU-consuming processes:"
ps axww -o pid,%cpu,comm | sort -k2 -nr | head -n 5 | while read -r pid cpu cmd; do
    if [[ -n "$cmd" && "$cmd" != -* ]]; then
        name=$(basename "$cmd")
    else
        name="$cmd"
    fi
    printf "  %-8s %-25s %s%%\n" "$pid" "$name" "$cpu"
done
echo ""
echo "🧠 Top 5 Memory-consuming processes:"
ps axww -o pid,rss,%mem,comm | sort -k2 -nr | head -n 5 | while read -r pid rss mem cmd; do
    if [[ -n "$cmd" && "$cmd" != -* ]]; then
        name=$(basename "$cmd")
    else
        name="$cmd"
    fi
    mem_mb=$((rss / 1024))
    printf "  %-8s %-25s %-6s %s MB\n" "$pid" "$name" "$mem" "$mem_mb"
done
