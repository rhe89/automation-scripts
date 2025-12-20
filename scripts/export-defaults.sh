#!/bin/zsh

settingsDir=~/Library/"Mobile Documents"/com~apple~CloudDocs/Settings

# For new exports, do e.g.:
# defaults export com.apple.Music  "$settingsDir/com.apple.Music.plist"

# Loop through each .plist file in the directory
for plistFile in "$settingsDir"/*.plist; do
    # Get just the filename without the path
    fileName=$(basename "$plistFile")
    # Remove .plist extension to get the defaults domain name
    domainName="${fileName%.plist}"
    
    # Export the defaults
    defaults export "$domainName" "$plistFile"
done

echo "export-defaults done"
