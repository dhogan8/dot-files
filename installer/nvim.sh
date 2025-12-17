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
    # Linux: Download from GitHub releases (more reliable than PPAs)
    echo "Installing Neovim from GitHub releases..."

    NVIM_VERSION="stable"
    NVIM_TARBALL="nvim-linux-arm64.tar.gz"
    if [ "$(uname -m)" = "x86_64" ]; then
        NVIM_TARBALL="nvim-linux-x86_64.tar.gz"
    fi

    cd /tmp
    curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_TARBALL}"
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf "$NVIM_TARBALL"
    sudo ln -sf /opt/nvim-linux-*/bin/nvim /usr/local/bin/nvim
    rm -f "$NVIM_TARBALL"
    cd -

    NVIM_BIN="/usr/local/bin/nvim"
fi

echo "Neovim installed at: $NVIM_BIN"
"$NVIM_BIN" --version

# Install vim-plug for neovim
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install nvim plugins
"$NVIM_BIN" +'PlugInstall --sync' +qa || true
"$NVIM_BIN" +'PlugUpdate --sync' +qa || true
"$NVIM_BIN" +'TSUpdate' +qa || true

echo "✓ Neovim installation complete"
exit 0
