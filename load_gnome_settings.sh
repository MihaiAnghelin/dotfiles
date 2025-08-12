#!/bin/bash
# Get the directory of the script itself
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Loading Dash to Dock settings..."
dconf load /org/gnome/shell/extensions/dash-to-dock/ < "$DIR/dash-to-dock.dconf"

echo "Done."