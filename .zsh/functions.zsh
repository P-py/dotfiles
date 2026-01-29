# Custom utility functions

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create a directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find a file by name
ff() {
    find . -type f -iname "*$1*"
}

# Find a directory by name
fd() {
    find . -type d -iname "*$1*"
}

# Quick search in files
search() {
    grep -r "$1" .
}

# Get current git branch
git_current_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# Quick git push to current branch
gpp() {
    git push origin $(git_current_branch)
}

# Quick git pull from current branch
gpl() {
    git pull origin $(git_current_branch)
}

# Show disk usage of current directory
duf() {
    du -h -d 1 | sort -h
}

# Show top processes by memory
topmem() {
    ps aux | sort -nrk 4 | head -n "${1:-10}"
}

# Show top processes by CPU
topcpu() {
    ps aux | sort -nrk 3 | head -n "${1:-10}"
}

# Quick weather check (requires curl)
weather() {
    curl "wttr.in/${1:-}"
}

# Generate a random password
genpass() {
    local length="${1:-16}"
    openssl rand -base64 "$length" | tr -d "=+/" | cut -c1-"$length"
}
