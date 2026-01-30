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
for cmd in git curl unzip zip; do
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

install_custom_theme() {
    local theme_src="$DOTFILES_DIR/.oh-my-zsh/custom/themes/sants.zsh-theme"
    local theme_dest="$ZSH_CUSTOM/themes/sants.zsh-theme"
    
    if [[ ! -f "$theme_src" ]]; then
        warn "Custom theme not found at $theme_src, skipping"
        return
    fi
    
    if [[ -f "$theme_dest" ]]; then
        if cmp -s "$theme_src" "$theme_dest"; then
            success "Custom theme already up to date"
            return
        fi
        warn "Updating custom theme"
    fi
    
    mkdir -p "$ZSH_CUSTOM/themes"
    cp "$theme_src" "$theme_dest"
    success "Custom theme installed"
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
    # Temporarily disable nounset to avoid issues with SDKMAN init script
    set +u
    # shellcheck disable=SC1090
    source "$init"
    # Re-enable nounset
    set -u
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

    # Disable nounset for SDK commands to avoid SDKMAN internal variable issues
    set +u

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
    
    # Re-enable nounset
    set -u
}

setup_git_ssh() {
    local ssh_dir="$HOME/.ssh"
    local ssh_key="$ssh_dir/dot-personal-git"
    local ssh_pub="$ssh_key.pub"
    
    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"
    
    # Check if SSH key already exists
    if [[ -f "$ssh_key" ]]; then
        success "SSH key already exists at $ssh_key"
    else
        info "Generating new SSH key (dot-personal-git)..."
        
        # Prompt for email
        local email
        read -rp "$(echo -e "${LABEL} ${CYAN}Enter your email for SSH key: ${RESET}")" email
        
        if [[ -z "$email" ]]; then
            warn "No email provided, skipping SSH key generation"
            return
        fi
        
        # Generate SSH key
        ssh-keygen -t ed25519 -C "$email" -f "$ssh_key" -N "" || {
            error "Failed to generate SSH key"
            return 1
        }
        
        success "SSH key generated at $ssh_key"
    fi
    
    # Start ssh-agent and add key
    if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
        info "Starting ssh-agent..."
        eval "$(ssh-agent -s)" > /dev/null
    fi
    
    # Add key to ssh-agent if not already added
    if ! ssh-add -l 2>/dev/null | grep -q "$ssh_key"; then
        info "Adding SSH key to ssh-agent..."
        ssh-add "$ssh_key" 2>/dev/null || warn "Failed to add key to ssh-agent"
    else
        success "SSH key already in ssh-agent"
    fi
    
    # Display public key
    if [[ -f "$ssh_pub" ]]; then
        install_custom_theme
        echo ""
        info "Your SSH public key:"
        echo ""
        echo "${BOLD}${GREEN}$(cat "$ssh_pub")${RESET}"
        echo ""
        info "Add this key to your Git hosting service (GitHub/GitLab/etc.)"
        info "GitHub: https://github.com/settings/ssh/new"
        info "GitLab: https://gitlab.com/-/profile/keys"
        echo ""
    fi
}

info "📦 Installing dotfiles from $DOTFILES_DIR"

install_oh_my_zsh

install_zsh_plugin "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions"

install_zsh_plugin "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting"

install_sdkman
install_sdks_from_rc

echo ""
setup_git_ssh

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
