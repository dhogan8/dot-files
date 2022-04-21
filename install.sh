#!/bin/bash

set -eux

PREFIX=~/dot-files

FILES_TO_LINK=(bashrc vimrc tmux.conf zshrc vim/coc-settings.json inputrc profile)

for FILE in "${FILES_TO_LINK[@]}"; do

  FROM="$HOME/.$FILE"
  if [[ ! -L "$FROM" ]]; then
    rm -f "$FROM"
    ln -sf "$PREFIX/$FILE" "$FROM"
  fi

done

WEZTERM="$HOME/.config/wezterm"
mkdir -p "$WEZTERM"
ln -sf $PREFIX/wezterm/wezterm.lua "$WEZTERM/wezterm.lua"

OHMYPOSH="$HOME/.config/oh-my-posh/themes"
mkdir -p "$OHMYPOSH"
ln -sf $PREFIX/oh-my-posh/themes/theme.omp.json "$OHMYPOSH/theme.omp.json"

mkdir -p "$HOME/local/bin"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa
vim +'PlugUpdate --sync' +qa
vim +':GoUpdateBinaries' +qa

if [ "$(uname)" == "Darwin" ]; then
  brew install go

  brew tap jandedobbeleer/oh-my-posh
  brew install oh-my-posh
  brew install --cask karabiner-elements
  mkdir -p $PREFIX/.config/karabiner
  ln -sf $PREFIX/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
  brew install tree
  brew tap homebrew/cask-fonts
  brew install --cask font-jetbrains-mono-nerd-font
  brew install tmux
  brew install bash
  brew install bash-completion
else
  FILE=oh-my-posh
  cd /tmp || exit
  curl --fail --location https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -o $FILE
  chmod +x $FILE
  mv $FILE ~/local/bin/
  sudo apt install tmux
  sudo apt install python3-pyx
fi

alias ls='ls --color=auto'

go install mvdan.cc/sh/v3/cmd/shfmt@latest
pip install --upgrade vim-vint

LOCALCHECKOUT=~/.tmux/plugins/tpm
if [ ! -d $LOCALCHECKOUT ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  pushd $LOCALCHECKOUT >/dev/null
  git pull origin master
  popd >/dev/null
fi

# tmux needs to be running in order to source a config file etc
# automatically update plugins
tmux new-session -d -s CI
tmux ls

tmux source ~/.tmux.conf

~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
~/.tmux/plugins/tpm/bin/clean_plugins

tmux kill-session -t CI

git config --global user.email "dhogan@maxmind.com"
git config --global user.name "Dallas Hogan"
git config --global branch.autosetuprebase always

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
