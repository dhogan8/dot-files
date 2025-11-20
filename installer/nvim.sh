#!/usr/bin/env bash

set -eux

if [ "$(uname)" == "Darwin" ]; then
    # macOS: Use Homebrew for stable release
    if ! command -v brew &> /dev/null; then
        echo "Error: Homebrew not installed. Please install Homebrew first."
        exit 1
    fi

    # Install or upgrade neovim via Homebrew
    if brew list neovim &>/dev/null; then
        echo "Neovim already installed via Homebrew, upgrading..."
        brew upgrade neovim || true
    else
        echo "Installing Neovim via Homebrew..."
        brew install neovim
    fi

    NVIM_BIN="$(brew --prefix)/bin/nvim"
else
    # Linux: Use system package manager
    if command -v apt-get &> /dev/null; then
        # Debian/Ubuntu - use unstable PPA for neovim 0.10+
        echo "Adding neovim unstable PPA..."
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository ppa:neovim-ppa/unstable -y
        echo "Installing Neovim via apt..."
        sudo apt-get update
        sudo apt-get install -y neovim
    elif command -v dnf &> /dev/null; then
        # Fedora/RHEL
        echo "Installing Neovim via dnf..."
        sudo dnf install -y neovim
    elif command -v yum &> /dev/null; then
        # Older RHEL/CentOS
        echo "Installing Neovim via yum..."
        sudo yum install -y neovim
    elif command -v pacman &> /dev/null; then
        # Arch Linux
        echo "Installing Neovim via pacman..."
        sudo pacman -S --noconfirm neovim
    elif command -v apk &> /dev/null; then
        # Alpine Linux
        echo "Installing Neovim via apk..."
        sudo apk add neovim
    else
        echo "Error: No supported package manager found (apt, dnf, yum, pacman, apk)"
        exit 1
    fi

    NVIM_BIN="$(command -v nvim)"
fi

echo "Neovim installed at: $NVIM_BIN"
"$NVIM_BIN" --version

# Install vim-plug for neovim
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install nvim plugins
"$NVIM_BIN" +'PlugInstall --sync' +qa || true
"$NVIM_BIN" +'PlugUpdate --sync' +qa || true

echo "✓ Neovim installation complete"
exit 0
