#!/bin/bash

# The directory where all GNOME backup data will be stored
BACKUP_DIR="$HOME/dotfiles/gnome-backup"
SETTINGS_DIR="$BACKUP_DIR/extensions-settings"

# Create the directories if they don't exist
mkdir -p "$SETTINGS_DIR"

echo "Backing up GNOME configuration to $BACKUP_DIR..."

# --- Part 1: Backup list of user-installed extensions ---
EXTENSIONS_LIST_FILE="$BACKUP_DIR/extensions-list.txt"
echo "-> Saving list of installed extensions to $EXTENSIONS_LIST_FILE..."
ls -1 ~/.local/share/gnome-shell/extensions/ > "$EXTENSIONS_LIST_FILE"

# --- Part 2: Backup the list of ENABLED extensions ---
ENABLED_EXTENSIONS_FILE="$BACKUP_DIR/enabled-extensions.txt"
echo "-> Saving list of enabled extensions..."
# We read the value from gsettings and save it to a file
gsettings get org.gnome.shell enabled-extensions > "$ENABLED_EXTENSIONS_FILE"

# --- Part 3: Backup dconf settings for each extension ---
for ext in $(dconf list /org/gnome/shell/extensions/); do
    # Get the clean name of the extension (e.g., "dash-to-dock")
    EXT_NAME=$(basename "$ext")
    DCONF_PATH="/org/gnome/shell/extensions/$ext"
    OUTPUT_FILE="$BACKUP_DIR/extensions-settings/$EXT_NAME.dconf"

    echo "-> Backing up $EXT_NAME..."
    dconf dump "$DCONF_PATH" > "$OUTPUT_FILE"
done

echo ""
echo "GNOME backup complete."