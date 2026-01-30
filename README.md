# 🏠 Dotfiles

Personal dotfiles for Linux configuration using [oh-my-zsh](https://ohmyz.sh/) and some nice plugins!

## ✨ Features

- **ZSH Configuration**: Complete oh-my-zsh setup with useful plugins
  - Git integration
  - Auto-suggestions and syntax highlighting
- **SDKMAN Integration**: Automatic installation and management of SDKs (Java, Gradle, Maven, etc.)
- **Git SSH Auto-Configuration**: Automated SSH key generation and setup for Git hosting services
- **Custom Functions**: Archive extraction, search utilities
- **System Aliases**: Quick access to system management commands
- **Smart Symlinking**: Automatic backup of existing configurations with timestamp

## 📦 Installation

### Prerequisites

- ZSH (install with: `sudo apt install zsh`)
- Git (install with: `sudo apt install git`)
- curl (install with: `sudo apt install curl`)
- unzip and zip (install with: `sudo apt install unzip zip`) - Required for SDKMAN
- ssh-keygen (usually pre-installed on most Linux/Unix systems)

### Quick Install

```bash
git clone https://github.com/P-py/dotfiles.git ~/.dotfiles

cd ~/.dotfiles

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
4. Install SDKMAN (Software Development Kit Manager)
6. Install SDKs specified in `.sdkmanrc` (if file exists)
7. Generate SSH keys for Git if not already present
8. Add SSH key to ssh-agent and display public key
9. Create symlinks for all dotfiles including custom .zsh configurations
10. SDKMAN Configuration

Update the `.sdkmanrc` file in the dotfiles directory to specify SDK versions to install:

```bash
# .sdkmanrc
java=21.0.5-tem
gradle=8.11.1
maven=3.9.6
```

## ⚙️ Configuration

### ZSH Customization

- Main config: `~/.zshrc`
- Custom functions: `~/.zsh/functions.zsh`
- Custom aliases: `~/.zsh/aliases.zsh`
- Local overrides: `~/.zshrc.local` (not tracked by git)

## 🛠️ Included Tools

### ZSH Plugins

- **git**: Git aliases and functions
- **zsh-autosuggestions**: Fish-like autosuggestions
- **zsh-syntax-highlighting**: Fish-like syntax highlighting

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