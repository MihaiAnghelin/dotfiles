#!/bin/bash

# The directory where all GNOME backup data is stored
BACKUP_DIR="$HOME/dotfiles/gnome-backup"
EXT_SETTINGS_DIR="$BACKUP_DIR/extensions-settings"
GNOME_SETTINGS_DIR="$BACKUP_DIR/gnome-core-settings"
EXTENSIONS_LIST_FILE="$BACKUP_DIR/extensions-list.txt"
ENABLED_EXTENSIONS_FILE="$BACKUP_DIR/enabled-extensions.txt"

# --- Safety Checks ---
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup directory not found: $BACKUP_DIR"
    exit 1
fi

if ! command -v gnome-shell-extension-installer &> /dev/null; then
    echo "ERROR: gnome-shell-extension-installer is not installed."
    echo "Please install it before running this script with these commands:"
    echo "wget -O gnome-shell-extension-installer \"https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer\""
    echo "chmod +x gnome-shell-extension-installer"
    echo "sudo mv gnome-shell-extension-installer /usr/local/bin/"
    exit 1
fi

echo "Restoring GNOME configuration from $BACKUP_DIR..."

# --- Part 1: Install all extensions from the list ---
if [ -f "$EXTENSIONS_LIST_FILE" ]; then
    echo "-> Installing extensions listed in $EXTENSIONS_LIST_FILE..."
    while read -r ext_uuid; do
        if [ -n "$ext_uuid" ]; then
            echo "   - Installing $ext_uuid..."
            gnome-shell-extension-installer "$ext_uuid"
        fi
    done < "$EXTENSIONS_LIST_FILE"
else
    echo "-> No extension list file found. Skipping installation."
fi

# --- Part 2: Restore dconf settings for each extension ---
echo "-> Restoring individual extension settings..."
for backup_file in "$EXT_SETTINGS_DIR"/*.dconf; do
    if [ -s "$backup_file" ]; then
        FILENAME=$(basename "$backup_file")
        EXT_NAME="${FILENAME%.dconf}"
        DCONF_PATH="/org/gnome/shell/extensions/$EXT_NAME/"
        echo "   - Restoring settings for $EXT_NAME..."
        dconf load "$DCONF_PATH" < "$backup_file"
    fi
done

# --- Part 3: Restore the list of ENABLED extensions ---
echo "-> Enabling previously active extensions..."
if [ -f "$ENABLED_EXTENSIONS_FILE" ]; then
    gsettings set org.gnome.shell enabled-extensions "$(cat "$ENABLED_EXTENSIONS_FILE")"
fi

# --- Part 4: Restore Core GNOME Settings ---
echo "-> Restoring core GNOME settings (Tweaks, Shortcuts, etc.)..."
if [ -d "$GNOME_SETTINGS_DIR" ]; then
    for file in "$GNOME_SETTINGS_DIR"/*.dconf; do
        if [ -f "$file" ]; then
            # Recreate the dconf path from the filename
            path="/$(basename "$file" .dconf | tr '.' '/')/"
            echo "   - Restoring settings for $path"
            dconf load "$path" < "$file"
        fi
    done
fi

echo ""
echo "GNOME restore complete."
echo "IMPORTANT: Please log out and log back in for all changes to take full effect."