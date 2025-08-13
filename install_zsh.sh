#!/bin/bash

echo "Starting Zsh setup..."

# --- Part 1: Install Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "-> Installing Oh My Zsh..."
    # The --unattended flag prevents the installer from trying to change the shell
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "-> Oh My Zsh is already installed."
fi

# --- Part 2: Install Custom Plugins ---
# Define the custom plugins directory
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Install zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
    echo "-> Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
else
    echo "-> zsh-autosuggestions is already installed."
fi

# Install zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
    echo "-> Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
else
    echo "-> zsh-syntax-highlighting is already installed."
fi

# --- Part 3: Symlink the .zshrc file ---
DOTFILES_ZSHRC="$HOME/dotfiles/.zshrc"
HOME_ZSHRC="$HOME/.zshrc"

echo "-> Setting up the .zshrc symbolic link..."

# Check if the target .zshrc in dotfiles exists
if [ ! -f "$DOTFILES_ZSHRC" ]; then
    echo "ERROR: .zshrc not found in dotfiles directory ($DOTFILES_ZSHRC)."
    echo "Please make sure it exists before running this script."
    exit 1
fi

# If a .zshrc file already exists in the home directory and is NOT a symlink, back it up
if [ -e "$HOME_ZSHRC" ] && [ ! -L "$HOME_ZSHRC" ]; then
    echo "   - Found existing .zshrc. Backing it up to .zshrc.pre-dotfiles-bak"
    mv "$HOME_ZSHRC" "$HOME/.zshrc.pre-dotfiles-bak"
fi

# Remove existing symlink if it exists, to prevent errors
if [ -L "$HOME_ZSHRC" ]; then
    rm "$HOME_ZSHRC"
fi

# Create the new symbolic link
echo "   - Creating symlink from $DOTFILES_ZSHRC to $HOME_ZSHRC"
ln -s "$DOTFILES_ZSHRC" "$HOME_ZSHRC"


echo ""
echo "Zsh setup complete."
echo "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
