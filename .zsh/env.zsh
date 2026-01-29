# Custom environment variables

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Add custom scripts to PATH if exists
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

# Set default apps
export BROWSER='firefox'
export TERMINAL='gnome-terminal'

# Development environment - only add to PATH if Go is installed
if command -v go &> /dev/null; then
    export GOPATH="$HOME/go"
    if [ -d "$GOPATH/bin" ]; then
        export PATH="$GOPATH/bin:$PATH"
    fi
fi

# Python
export PYTHONDONTWRITEBYTECODE=1

# Node version manager (if installed)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
