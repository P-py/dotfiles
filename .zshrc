# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set theme - see https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="sants"

# Plugins to load
# Standard plugins: $ZSH/plugins/
# Custom plugins: $ZSH_CUSTOM/plugins/
plugins=(
    git
    # docker
    # docker-compose
    # kubectl
    # python
    # pip
    # npm
    # node
    # sudo
    # command-not-found
    # colored-man-pages
    zsh-autosuggestions
    zsh-syntax-highlighting
    # history-substring-search
)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Only run in interactive shells
if [[ $- == *i* ]]; then
  # Reuse existing agent if valid
  if [[ -n "$SSH_AUTH_SOCK" && -S "$SSH_AUTH_SOCK" ]]; then
    :
  else
    # Start a new agent
    if command -v ssh-agent >/dev/null 2>&1; then
      eval "$(ssh-agent -s)" >/dev/null
    fi
  fi

  # Add SSH key with timeout (8 hours)
  if [[ -n "$SSH_AUTH_SOCK" && -S "$SSH_AUTH_SOCK" ]]; then
    ssh-add -l >/dev/null 2>&1 || {
      ssh-add -t 8h ~/.ssh/dot-personal-git 2>/dev/null
    }
  fi
fi

# Preferred editor
export EDITOR='nano'

alias grep='grep --color=auto'

# Simple tips (only for interactive shells)
if [[ $- == *i* ]]; then
  echo "aliases(update, cleanup, install, remove, aptsearch)"
  echo "functions(extract, ff, finddir, grepsearch)"
fi

# Load custom configurations if they exist
if [ -d "$HOME/.zsh" ]; then
    for file in $HOME/.zsh/*.zsh; do
        [ -f "$file" ] && source "$file"
    done
fi

# Load local customizations if they exist
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"