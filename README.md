# 🏠 Dotfiles

Personal dotfiles for Linux configuration using [oh-my-zsh](https://ohmyz.sh/) and some nice plugins!

## ✨ Features

- **ZSH Configuration**: Complete oh-my-zsh setup with useful plugins
  - Git integration
  - Auto-suggestions and syntax highlighting
- **Custom Functions**: Archive extraction, search utilities
- **System Aliases**: Quick access to system management commands

## 📦 Installation

### Prerequisites

- ZSH (install with: `sudo apt install zsh`)
- Git (install with: `sudo apt install git`)
- curl (install with: `sudo apt install curl`)

### Quick Install

```bash
# Clone the repository to ~/.dotfiles (recommended location)
git clone https://github.com/P-py/dotfiles.git ~/.dotfiles

# Navigate to the directory
cd ~/.dotfiles

# Run the installation script
./install.sh
```

**Important Notes:**
- The installation script will download and execute the oh-my-zsh installation script from the internet. Review it first for security if needed.
- If you clone to a different location, symlinks will still work as the script uses absolute paths.
- The script will backup any existing configuration files to `*.backup`

The installation script will:
1. Check for required dependencies (git, curl)
2. Install oh-my-zsh if not already installed
3. Install zsh-autosuggestions plugin
4. Install zsh-syntax-highlighting plugin
5. Create symlinks for all dotfiles including custom .zsh configurations
6. Backup any existing configuration files

## ⚙️ Configuration

### ZSH Customization

- Main config: `~/.zshrc`
- Custom functions: `~/.zsh/functions.zsh`
- Custom aliases: `~/.zsh/aliases.zsh`
- Local overrides: `~/.zshrc.local` (not tracked by git)

## 🛠️ Included Tools

### ZSH Plugins

- **git**: Git aliases and functions
- **docker**: Docker command completion
- **docker-compose**: Docker Compose completion
- **kubectl**: Kubernetes command completion
- **python/pip**: Python development tools
- **npm/node**: Node.js development tools
- **sudo**: Double ESC to add sudo to previous command
- **command-not-found**: Suggests package for unknown commands
- **colored-man-pages**: Colorized man pages
- **zsh-autosuggestions**: Fish-like autosuggestions
- **zsh-syntax-highlighting**: Fish-like syntax highlighting
- **history-substring-search**: Better history search

### Custom Functions

- `extract <file>`: Extract any archive format
- `ff <name>`: Find files by name
- `finddir <name>`: Find directories by name
- `grepsearch <term>`: Grep search in current directory

### Useful Aliases

**System:**
- `update`: Update system packages
- `cleanup`: Clean up old packages
- `install <pkg>`: Install package

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Feel free to fork this repository and customize it to your needs! If you have suggestions for improvements, please open an issue or pull request.

## 🙏 Credits

- [oh-my-zsh](https://ohmyz.sh/)
- [zsh-users](https://github.com/zsh-users)
- All the amazing open-source contributors!