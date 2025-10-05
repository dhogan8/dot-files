#!/usr/bin/env bash

# May need to sudo apt install libfuse2 on Ubuntu >= 22.04
# https://docs.appimage.org/user-guide/troubleshooting/fuse.html

set -eux

pushd /tmp || exit

URL=https://github.com/neovim/neovim/releases/download/nightly/

if [ "$(uname)" == "Darwin" ]; then
    DIR=nvim-macos-arm64
    FILE="$DIR.tar.gz"
    rm -rf $DIR
else
    # Detect Linux architecture
    ARCH=$(uname -m)
    if [ "$ARCH" == "aarch64" ] || [ "$ARCH" == "arm64" ]; then
        FILE=nvim-linux-arm64.appimage
    else
        FILE=nvim-linux-x86_64.appimage
    fi
fi

curl -LO --fail -z $FILE "$URL$FILE"

if [ "$(uname)" == "Darwin" ]; then
    tar xzvf $FILE
    dest="$HOME/local/bin/nvim-macos"
    rm -rf "$dest"
    mv $DIR "$dest"
    rm -f "$HOME/local/bin/nvim"
    add_path "$HOME/local/bin/nvim-macos/bin"
else
    chmod u+x $FILE
    mv $FILE "$HOME/local/bin/nvim"
fi

echo "done nvim install"
exit 0
