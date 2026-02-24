#!/bin/bash
set -euo pipefail

DRY_RUN=false
if [ "${1:-}" = "--dry-run" ]; then
    DRY_RUN=true
    echo "=== DRY RUN MODE - no changes will be made ==="
    echo ""
fi

# The directory where all GNOME backup data is stored
BACKUP_DIR="$HOME/dotfiles/gnome-backup"
EXT_SETTINGS_DIR="$BACKUP_DIR/extensions-settings"
GNOME_SETTINGS_DIR="$BACKUP_DIR/gnome-core-settings"
EXTENSIONS_LIST_FILE="$BACKUP_DIR/extensions-list.txt"
ENABLED_EXTENSIONS_FILE="$BACKUP_DIR/enabled-extensions.txt"

# --- Safety Checks ---
if [ ! -d "$BACKUP_DIR" ]; then
    echo "ERROR: Backup directory not found: $BACKUP_DIR"
    exit 1
fi

for cmd in dconf gsettings; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "ERROR: '$cmd' is not installed."
        exit 1
    fi
done

if ! command -v gnome-shell-extension-installer &> /dev/null; then
    echo "ERROR: gnome-shell-extension-installer is not installed."
    echo "Please install it before running this script with these commands:"
    echo "  wget -O gnome-shell-extension-installer \"https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer\""
    echo "  chmod +x gnome-shell-extension-installer"
    echo "  sudo mv gnome-shell-extension-installer /usr/local/bin/"
    exit 1
fi

# --- Safety backup of current settings before restoring ---
if [ "$DRY_RUN" = false ]; then
    echo "-> Creating safety backup of current settings..."
    SAFETY_DIR="$BACKUP_DIR/../gnome-backup-pre-restore-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$SAFETY_DIR"
    dconf dump /org/gnome/shell/extensions/ > "$SAFETY_DIR/extensions-all.dconf"
    dconf dump /org/gnome/desktop/ > "$SAFETY_DIR/desktop-all.dconf"
    gsettings get org.gnome.shell enabled-extensions > "$SAFETY_DIR/enabled-extensions.txt"
    echo "   Saved to $SAFETY_DIR"
fi

echo "Restoring GNOME configuration from $BACKUP_DIR..."

# --- Part 1: Install all extensions from the list ---
if [ -f "$EXTENSIONS_LIST_FILE" ]; then
    echo "-> Installing extensions listed in $EXTENSIONS_LIST_FILE..."
    while read -r ext_uuid; do
        if [ -n "$ext_uuid" ]; then
            if [ "$DRY_RUN" = true ]; then
                echo "   - [dry-run] Would install $ext_uuid"
            else
                echo "   - Installing $ext_uuid..."
                gnome-shell-extension-installer "$ext_uuid" || echo "   WARNING: Failed to install $ext_uuid"
            fi
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
        if [ "$DRY_RUN" = true ]; then
            echo "   - [dry-run] Would restore settings for $EXT_NAME"
        else
            echo "   - Restoring settings for $EXT_NAME..."
            dconf load "$DCONF_PATH" < "$backup_file"
        fi
    fi
done

# --- Part 3: Restore the list of ENABLED extensions ---
echo "-> Enabling previously active extensions..."
if [ -f "$ENABLED_EXTENSIONS_FILE" ]; then
    if [ "$DRY_RUN" = true ]; then
        echo "   - [dry-run] Would enable: $(cat "$ENABLED_EXTENSIONS_FILE")"
    else
        gsettings set org.gnome.shell enabled-extensions "$(cat "$ENABLED_EXTENSIONS_FILE")"
    fi
fi

# --- Part 4: Restore Core GNOME Settings ---
echo "-> Restoring core GNOME settings (Tweaks, Shortcuts, etc.)..."
if [ -d "$GNOME_SETTINGS_DIR" ]; then
    for file in "$GNOME_SETTINGS_DIR"/*.dconf; do
        if [ -f "$file" ]; then
            # Reconstruct dconf path from filename, handling both old (double-dot) and new formats
            path="/$(basename "$file" .dconf | sed 's/\.$//' | tr '.' '/')/"
            if [ "$DRY_RUN" = true ]; then
                echo "   - [dry-run] Would restore settings for $path"
            else
                echo "   - Restoring settings for $path"
                dconf load "$path" < "$file"
            fi
        fi
    done
fi

echo ""
echo "GNOME restore complete."
if [ "$DRY_RUN" = false ]; then
    echo "IMPORTANT: Please log out and log back in for all changes to take full effect."
fi
