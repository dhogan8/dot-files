#!/bin/bash

set -eux

PREFIX=~/dot-files

FILES_TO_LINK=(bashrc vimrc)

for FILE in ${FILES_TO_LINK[@]}; do

    FROM="$HOME/.$FILE"
    if [[ ! -L "$FROM" ]]; then
        rm -f "$FROM"
        ln -sf $PREFIX/$FILE $FROM
    fi

done

WEZTERM="$HOME/.config/wezterm"
mkdir -p "$WEZTERM"
ln -sf $PREFIX/wezterm/wezterm.lua $WEZTERM/wezterm.lua

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa
vim +'PlugUpdate --sync' +qa

if [ “$(uname)” == “Darwin” ]; then
    brew install go

    brew tap jandedobbeleer/oh-my-posh
    brew install oh-my-posh
    brew install --cask karabiner-elements
    mkdir -p $PREFIX/.config/karabiner
    ln -sf $PREFIX/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
    brew install tree
fi

alias ls='ls --color=auto'

git config --global user.email "dhogan@maxmind.com"
git config --global user.name "Dallas Hogan"

git config --global alias.b 'branch'
git config --global alias.ca 'commit --amend'
git config --global alias.can 'commit --amend --no-edit'
git config --global alias.ct 'commit'
git config --global alias.co 'checkout'
git config --global alias.dc 'diff --cached'
git config --global alias.doms 'diff -w -M origin/main...HEAD --stat --name-only'
git config --global alias.prom 'pull --rebase origin master'
git config --global alias.pf 'push --force-with-lease'
git config --global alias.undo 'reset --soft HEAD^'
git config --global alias.st 'status'

