# shellcheck disable=SC1090
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="$PATH:$HOME/.rvm/bin"
export EDITOR=vim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export YVM_DIR=/Users/dallas/.yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dallas/Desktop/google-cloud-sdk/path.bash.inc' ]; then . '/Users/dallas/Desktop/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dallas/Desktop/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/dallas/Desktop/google-cloud-sdk/completion.bash.inc'; fi

alias ls='ls --color=auto'
alias s='source ~/.bashrc'

alias tm='tmux'
alias tmas='tmux attach-session -t'
alias tmks='tmux kill-session -t'
alias tmkp='tm kill-pane'
alias tmd='tmux detach'

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

eval "$(oh-my-posh prompt init bash --config ~/.config/oh-my-posh/themes/theme.omp.json)"

export PROMPT_COMMAND="_omp_hook; history -a"
