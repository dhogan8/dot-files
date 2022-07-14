# shellcheck disable=SC1090
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="$PATH:$HOME/.rvm/bin"
export EDITOR=vim

add_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1:$PATH"
  fi
}

[ -f "$HOME"/.vim/plugged/fzf/shell/key-bindings.bash ] && . "$HOME"/.vim/plugged/fzf/shell/key-bindings.bash
[ -f "$HOME"/.vim/plugged/fzf/shell/completion.bash ] && . "$HOME"/.vim/plugged/fzf/shell/completion.bash
[ -f "$HOME"/dot-files/local_bashrc ] && . "$HOME"/dot-files/local_bashrc

add_path "$HOME/.vim/plugged/fzf/bin"
add_path "$HOME/local/bin"

set -o vi

unset PS1

whosonport() {
  sudo lsof +c 0 -i :"$1"
}

rename_tab() {
  if test "${TMUX_PANE+x}"; then
    echo -en "\033Ptmux;\033\033]0;$1\a\033\\"
  else
    echo -en "\033]0;$1\a"
  fi
}

# shellcheck disable=SC2046

export PROMPT_COMMAND="_omp_hook; history -a"
export PATH
