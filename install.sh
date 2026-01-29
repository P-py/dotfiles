#!/usr/bin/env bash

# Dotfiles installation script
# This script creates symlinks from the home directory to the dotfiles

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 Installing dotfiles from $DOTFILES_DIR"

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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ oh-my-zsh already installed"
fi

# Install zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "📥 Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "✅ zsh-autosuggestions already installed"
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "📥 Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo "✅ zsh-syntax-highlighting already installed"
fi

# Create .zsh directory for custom configurations
mkdir -p "$HOME/.zsh"

# Link dotfiles
echo ""
echo "🔗 Creating symlinks..."
link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Copy gitignore_global if exists
if [ -f "$DOTFILES_DIR/.gitignore_global" ]; then
    link_file "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
fi

echo ""
echo "✨ Dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "  1. Edit ~/.gitconfig to set your name and email"
echo "  2. Restart your shell or run: source ~/.zshrc"
echo "  3. Enjoy your new setup! 🎉"
