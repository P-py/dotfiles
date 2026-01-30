#!/usr/bin/env bash

# Dotfiles installation script
# This script creates symlinks from the home directory to the dotfiles

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 Installing dotfiles from $DOTFILES_DIR"

# Check for required commands
for cmd in git curl; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "❌ Error: $cmd is not installed. Please install it first."
        exit 1
    fi
done

# Function to create symlink
link_file() {
    local src=$1
    local dest=$2
    
    if [ -e "$dest" ]; then
        if [ -L "$dest" ]; then
            echo "⚠️  Removing existing symlink: $dest"
            rm "$dest"
        else
            echo "⚠️  Backing up existing file: $dest to $dest.backup"
            mv "$dest" "$dest.backup"
        fi
    fi
    
    echo "🔗 Linking $src -> $dest"
    ln -s "$src" "$dest"
}

# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📥 Installing oh-my-zsh..."
    # Note: This downloads and executes a script from the internet
    # Review the script at the URL before running on production systems
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
        echo "❌ Failed to install oh-my-zsh"
        exit 1
    }
else
    echo "✅ oh-my-zsh already installed"
fi

# Install zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "📥 Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions || {
        echo "❌ Failed to install zsh-autosuggestions"
        exit 1
    }
else
    echo "✅ zsh-autosuggestions already installed"
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "📥 Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting || {
        echo "❌ Failed to install zsh-syntax-highlighting"
        exit 1
    }
else
    echo "✅ zsh-syntax-highlighting already installed"
fi

# Create .zsh directory for custom configurations
mkdir -p "$HOME/.zsh"

# Link dotfiles
echo ""
echo "🔗 Creating symlinks..."
link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Link custom zsh configuration files
link_file "$DOTFILES_DIR/.zsh/aliases.zsh" "$HOME/.zsh/aliases.zsh"
link_file "$DOTFILES_DIR/.zsh/functions.zsh" "$HOME/.zsh/functions.zsh"

echo ""
echo "✨ Dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. Enjoy your new setup! 🎉"
