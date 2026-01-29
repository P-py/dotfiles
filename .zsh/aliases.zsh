# Additional useful aliases

# System
alias update='sudo apt update && sudo apt upgrade -y'
alias cleanup='sudo apt autoremove -y && sudo apt autoclean'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'

# Navigation
alias home='cd ~'
alias docs='cd ~/Documents'
alias dl='cd ~/Downloads'
alias dev='cd ~/Development'

# File operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -pv'

# List operations
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -ltrh'
alias lsize='ls -lSrh'

# Network
alias ports='netstat -tulanp'
alias myip='curl ifconfig.me'
alias localip='hostname -I'
alias ping='ping -c 5'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# Process management
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias killall='killall -v'

# System monitoring
alias meminfo='free -m -l -t'
alias cpuinfo='lscpu'
alias diskinfo='df -h'

# Git shortcuts
alias gst='git status'
alias gaa='git add .'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gpo='git push origin'
alias gpom='git push origin main'
alias glog='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Docker
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcr='docker-compose restart'
alias dcl='docker-compose logs -f'
alias dclean='docker system prune -a'
alias dstop='docker stop $(docker ps -aq)'

# Python
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv venv'
alias activate='source venv/bin/activate'

# Misc
alias h='history'
alias j='jobs -l'
alias c='clear'
alias q='exit'
alias reload='source ~/.zshrc'
alias edit='$EDITOR'
alias zshconfig='$EDITOR ~/.zshrc'
alias vimconfig='$EDITOR ~/.vimrc'
alias tmuxconfig='$EDITOR ~/.tmux.conf'
