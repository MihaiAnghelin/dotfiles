#!/bin/bash

# The directory where settings will be backed up, inside your dotfiles folder
BACKUP_DIR="$HOME/dotfiles/gnome-extensions-settings"

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "Backing up GNOME Shell extension settings to $BACKUP_DIR..."

# Get a list of all extensions that have dconf settings
for ext in $(dconf list /org/gnome/shell/extensions/); do
    # Get the clean name of the extension (e.g., "dash-to-dock")
    EXT_NAME=$(basename "$ext")
    DCONF_PATH="/org/gnome/shell/extensions/$ext"
    OUTPUT_FILE="$BACKUP_DIR/$EXT_NAME.dconf"

    echo "-> Backing up $EXT_NAME..."
    dconf dump "$DCONF_PATH" > "$OUTPUT_FILE"
done

echo ""
echo "All extension settings have been backed up."