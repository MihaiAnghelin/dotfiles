#!/bin/bash

# The directory where all GNOME backup data will be stored
BACKUP_DIR="$HOME/dotfiles/gnome-backup"
EXT_SETTINGS_DIR="$BACKUP_DIR/extensions-settings"
GNOME_SETTINGS_DIR="$BACKUP_DIR/gnome-core-settings"

# Create the directories if they don't exist
mkdir -p "$EXT_SETTINGS_DIR"
mkdir -p "$GNOME_SETTINGS_DIR"

echo "Backing up GNOME configuration to $BACKUP_DIR..."

# --- Part 1: Backup list of user-installed extensions ---
EXTENSIONS_LIST_FILE="$BACKUP_DIR/extensions-list.txt"
echo "-> Saving list of installed extensions..."
ls -1 ~/.local/share/gnome-shell/extensions/ > "$EXTENSIONS_LIST_FILE"

# --- Part 2: Backup the list of ENABLED extensions ---
ENABLED_EXTENSIONS_FILE="$BACKUP_DIR/enabled-extensions.txt"
echo "-> Saving list of enabled extensions..."
gsettings get org.gnome.shell enabled-extensions > "$ENABLED_EXTENSIONS_FILE"

# --- Part 3: Backup dconf settings for each extension ---
echo "-> Backing up individual extension settings..."
for ext in $(dconf list /org/gnome/shell/extensions/); do
    EXT_NAME=$(basename "$ext")
    DCONF_PATH="/org/gnome/shell/extensions/$ext"
    OUTPUT_FILE="$EXT_SETTINGS_DIR/$EXT_NAME.dconf"
    
    echo "   - Backing up settings for $EXT_NAME"
    dconf dump "$DCONF_PATH" > "$OUTPUT_FILE"
done

# --- Part 4: Backup Core GNOME & Tweaks Settings ---
echo "-> Backing up core GNOME settings (Tweaks, Shortcuts, etc.)..."
DCONF_PATHS=(
    "/org/gnome/desktop/interface/" # GTK theme, icons, fonts, etc.
    "/org/gnome/desktop/wm/preferences/" # Window titlebar buttons, etc.
    "/org/gnome/desktop/wm/keybindings/" # Window manager keyboard shortcuts
    "/org/gnome/settings-daemon/plugins/media-keys/" # Media keys and custom shortcuts
    "/org/gnome/desktop/background/" # Wallpaper settings
    "/org/gnome/desktop/peripherals/" # Mouse, touchpad, and keyboard settings
)
for path in "${DCONF_PATHS[@]}"; do
    # Create a valid filename from the dconf path (e.g., /org/gnome/ -> org.gnome.dconf)
    filename=$(echo "$path" | sed 's/^\///; s/\//./g').dconf
    echo "   - Saving settings for $path"
    dconf dump "$path" > "$GNOME_SETTINGS_DIR/$filename"
done

echo ""
echo "GNOME backup complete."