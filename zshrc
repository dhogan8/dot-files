# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
autoload -Uz compinit && compinit

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export YVM_DIR=/Users/dallas/.yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dallas/Desktop/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dallas/Desktop/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dallas/Desktop/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dallas/Desktop/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(oh-my-posh prompt init zsh --config ~/.config/oh-my-posh/themes/theme.omp.json)"

alias ls='ls --color=auto'

alias tm='tmux'
alias tmls='tmux ls'
alias tmas='tmux attach-session -t'
alias tmks='tmux kill-session -t'
alias tmkp='tm kill-pane'
alias tmd='tmux detach'
alias tmns='tmux new -s'

rename_tab() {
  if test "${TMUX_PANE+x}"; then
    echo -en "\033Ptmux;\033\033]0;$1\a\033\\"
  else
    echo -en "\033]0;$1\a"
  fi
}
