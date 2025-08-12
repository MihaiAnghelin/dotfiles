#!/bin/bash

# The directory where settings are backed up
BACKUP_DIR="$HOME/dotfiles/gnome-extensions-settings"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup directory not found: $BACKUP_DIR"
    exit 1
fi

echo "Restoring GNOME Shell extension settings from $BACKUP_DIR..."

# Loop through all .dconf files in the backup directory
for backup_file in "$BACKUP_DIR"/*.dconf; do
    # Derive the extension name from the filename
    FILENAME=$(basename "$backup_file")
    EXT_NAME="${FILENAME%.dconf}"
    DCONF_PATH="/org/gnome/shell/extensions/$EXT_NAME/"

    echo "-> Restoring settings for $EXT_NAME..."
    dconf load "$DCONF_PATH" < "$backup_file"
done

echo ""
echo "All extension settings restored."
echo "You may need to log out and log back in to see all changes."