#!/usr/bin/env bash

# Dotfiles installation script
# This script creates symlinks from the home directory to the dotfiles

set -Eeuo pipefail
IFS=$'\n\t'

NO_COLOR=${NO_COLOR:-}
if [[ "${1:-}" == "--no-color" ]]; then NO_COLOR=1; shift || true; fi

supports_color() {
    [[ -t 1 ]] || return 1
    if command -v tput >/dev/null 2>&1; then
        local ncolors
        ncolors="$(tput colors || echo 0)"
        [[ -n "$ncolors" && "$ncolors" -ge 8 ]]
    else
        return 1
    fi
}

if [[ -n "$NO_COLOR" ]] || ! supports_color; then
    RESET=""; BOLD=""; DIM=""; RED=""; GREEN=""; YELLOW=""; BLUE=""; MAGENTA=""; CYAN=""; WHITE=""
else
    RESET="$(tput sgr0)"
    BOLD="$(tput bold)"
    DIM="$(tput dim)"
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    MAGENTA="$(tput setaf 5)"
    CYAN="$(tput setaf 6)"
    WHITE="$(tput setaf 7)"
fi

LABEL="${BOLD}[${MAGENTA}DOTFILES${RESET}${BOLD}]${RESET}"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

info () { echo -e "${LABEL} ${CYAN}$*${RESET}"; }
error () { echo -e "${LABEL} ${RED}$*${RESET}" >&2; }
warn () { echo -e "${LABEL} ${YELLOW}$*${RESET}"; }
success () { echo -e "${LABEL} ${GREEN}$*${RESET}"; }

require_commands() {
    command -v "$1" &> /dev/null || { error "Required command '$1' not found. Please install it." && exit 1; }
}

# Check for required commands
for cmd in git curl; do
    require_commands "$cmd"
done

# Function to create symlink
link_file() {
    local src=$1
    local dest=$2

    [[ -e "$src" ]] || { error "Source file $src does not exist." && return 1; }
    
    if [[ -L "$dest" ]]; then
        if [[ "$(readlink "$dest")" == "$src" ]]; then
            success "Symlink already correct: $dest"
            return
        fi
        warn "Replacing incorrect symlink: $dest"
        rm "$dest"
    elif [[ -e "$dest" ]]; then
        mkdir -p "$BACKUP_DIR"
        local backup="$BACKUP_DIR/$(basename "$dest").$(date +%s)"
        warn "Backing up $dest → $backup"
        mv "$dest" "$backup"
    fi

    ln -s "$src" "$dest"
    success "Linked $dest → $src"
}

install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        success "oh-my-zsh already installed"
        return
    fi

    info "Installing oh-my-zsh (unattended)"
    local installer
    installer="$(mktemp)"

    curl -fsSL \
        https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
        -o "$installer"

    bash "$installer" --unattended
    rm -f "$installer"

    success "oh-my-zsh installed"
}


install_zsh_plugin() {
    local name="$1"
    local repo="$2"
    local dir="$ZSH_CUSTOM/plugins/$name"

    if [[ -d "$dir" ]]; then
        success "Plugin already installed: $name"
        return
    fi

    info "Installing plugin: $name"
    git clone --depth=1 "$repo" "$dir"
    success "Plugin installed: $name"
}

install_sdkman() {
    if [[ -d "$HOME/.sdkman" ]]; then
        success "SDKMAN already installed"
        return
    fi

    info "Installing SDKMAN"
    curl -fsSL https://get.sdkman.io | bash
    success "SDKMAN installed"
}

load_sdkman() {
    local init="$HOME/.sdkman/bin/sdkman-init.sh"
    [[ -f "$init" ]] || error "SDKMAN init not found"
    # shellcheck disable=SC1090
    source "$init"
}

install_sdks_from_rc() {
    local rc="$DOTFILES_DIR/.sdkmanrc"
    if [[ ! -f "$rc" ]]; then
        info "No .sdkmanrc file found, skipping SDK installation"
        return
    fi

    if [[ ! -d "$HOME/.sdkman" ]]; then
        error "SDKMAN not installed, cannot install SDKs"
        return 1
    fi

    load_sdkman

    info "Installing SDKs from .sdkmanrc"

    while IFS='=' read -r candidate version; do
        [[ -z "$candidate" || "$candidate" =~ ^# ]] && continue

        candidate="$(xargs <<<"$candidate")"
        version="$(xargs <<<"$version")"

        if [[ -d "$HOME/.sdkman/candidates/$candidate/$version" ]]; then
            success "$candidate $version already installed"
        else
            info "Installing $candidate $version"
            sdk install "$candidate" "$version" || warn "Failed: $candidate $version"
        fi
    done < "$rc"
}

info "📦 Installing dotfiles from $DOTFILES_DIR"

install_oh_my_zsh

install_zsh_plugin "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions"

install_zsh_plugin "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting"

install_sdkman
install_sdks_from_rc

# Create .zsh directory for custom configurations
mkdir -p "$HOME/.zsh"

# Link dotfiles
echo ""
info "Creating symlinks..."
[[ -f "$DOTFILES_DIR/.zshrc" ]] && link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc" || warn ".zshrc not found in dotfiles"
[[ -f "$DOTFILES_DIR/.zsh/aliases.zsh" ]] && link_file "$DOTFILES_DIR/.zsh/aliases.zsh" "$HOME/.zsh/aliases.zsh" || warn ".zsh/aliases.zsh not found"
[[ -f "$DOTFILES_DIR/.zsh/functions.zsh" ]] && link_file "$DOTFILES_DIR/.zsh/functions.zsh" "$HOME/.zsh/functions.zsh" || warn ".zsh/functions.zsh not found"

echo ""
echo "✨ Dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. Enjoy your new setup! 🎉"
