export BASH_SILENCE_DEPRECATION_WARNING=1

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# path handling
# http://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
add_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1:$PATH"
  fi
}

# Setting PATH for Python 3.8
# The original version is saved in .bash_profile.pysave
add_path "/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(oh-my-posh prompt init bash --config ~/.config/oh-my-posh/themes/theme.omp.json)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/google-cloud-sdk/path.bash.inc' ]; then . '~/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '~/google-cloud-sdk/completion.bash.inc' ]; then . '~/google-cloud-sdk/completion.bash.inc'; fi

alias ls='ls --color=auto'
alias s='source ~/.bashrc'

alias tm='tmux'
alias tmls='tmux ls'
alias tmas='tmux attach-session -t'
alias tmks='tmux kill-session -t'
alias tmkp='tm kill-pane'
alias tmd='tmux detach'
alias tmns='tmux new -s'

export PATH
