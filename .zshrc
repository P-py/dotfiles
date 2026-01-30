# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set theme - see https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="bureau"

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

# User configuration

# Preferred editor
export EDITOR='nano'

alias grep='grep --color=auto'

# Load custom configurations if they exist
if [ -d "$HOME/.zsh" ]; then
    for file in $HOME/.zsh/*.zsh; do
        [ -f "$file" ] && source "$file"
    done
fi

# Load local customizations if they exist
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
