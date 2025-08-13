#!/bin/bash

# The directory where GNOME backup data is stored
BACKUP_DIR="$HOME/dotfiles/gnome-backup"
SETTINGS_DIR="$BACKUP_DIR/extensions-settings"
EXTENSIONS_LIST_FILE="$BACKUP_DIR/extensions-list.txt"
ENABLED_EXTENSIONS_FILE="$BACKUP_DIR/enabled-extensions.txt"

# Check for the installer dependency
if ! command -v gnome-shell-extension-installer &> /dev/null; then
    echo "ERROR: gnome-shell-extension-installer is not installed."
    echo "Please install it before running this script."
	echo "wget -O gnome-shell-extension-installer \"https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer\""
	echo "chmod +x gnome-shell-extension-installer"
	echo "sudo mv gnome-shell-extension-installer /usr/local/bin/"
    exit 1
fi

echo "Restoring GNOME configuration from $BACKUP_DIR..."

# --- Part 1: Install all extensions from the list ---
echo "-> Installing extensions listed in $EXTENSIONS_LIST_FILE..."
while read -r ext_uuid; do
    echo "   - Installing $ext_uuid..."
    gnome-shell-extension-installer "$ext_uuid"
done < "$EXTENSIONS_LIST_FILE"

# --- Part 2: Restore dconf settings for each extension ---
echo "-> Restoring individual extension settings..."
for backup_file in "$SETTINGS_DIR"/*.dconf; do
    FILENAME=$(basename "$backup_file")
    EXT_NAME="${FILENAME%.dconf}"
    DCONF_PATH="/org/gnome/shell/extensions/$EXT_NAME/"

    echo "   - Restoring settings for $EXT_NAME..."
    dconf load "$DCONF_PATH" < "$backup_file"
done

# --- Part 3: Restore the list of ENABLED extensions ---
echo "-> Enabling previously active extensions..."
if [ -f "$ENABLED_EXTENSIONS_FILE" ]; then
    gsettings set org.gnome.shell enabled-extensions "$(cat "$ENABLED_EXTENSIONS_FILE")"
fi

echo ""
echo "GNOME restore complete."
echo "IMPORTANT: Please log out and log back in for all changes to take full effect."