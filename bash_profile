 export BASH_SILENCE_DEPRECATION_WARNING=1
 # Setting PATH for Python 3.8
 # The original version is saved in .bash_profile.pysave
 PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
 export PATH

# Setting PATH for Python 3.8
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
export PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dally/google-cloud-sdk/path.bash.inc' ]; then . '/Users/dally/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dally/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/dally/google-cloud-sdk/completion.bash.inc'; fi

eval "$(oh-my-posh prompt init bash --config ~/.config/oh-my-posh/themes/theme.omp.json)"

alias ls='ls --color=auto'
alias s='source ~/.bashrc'

alias tm='tmux'
alias tmls='tmux ls'
alias tmas='tmux attach-session -t'
alias tmks='tmux kill-session -t'
alias tmkp='tm kill-pane'
alias tmd='tmux detach'
alias tmns='tmux new -s'
