#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Installer ==="
echo ""

# --- Zsh Setup ---
echo "[1/2] Setting up Zsh..."
bash "$SCRIPT_DIR/install_zsh.sh"
echo ""

# --- GNOME Restore ---
read -p "[2/2] Restore GNOME settings? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    bash "$SCRIPT_DIR/restore_gnome.sh"
else
    echo "Skipped GNOME restore."
fi

echo ""
echo "=== All done! ==="
