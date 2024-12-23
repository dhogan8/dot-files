export BASH_SILENCE_DEPRECATION_WARNING=1

# Bash completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Git completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# path handling
# http://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
add_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1:$PATH"
  fi
}
export -f add_path

# Setting PATH for Python 3.8
# The original version is saved in .bash_profile.pysave
add_path "/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"

# Set PATH, MANPATH, etc., for Homebrew.
if [ "$(uname)" == "Darwin" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  add_path ~/local/bin/nvim-macos/bin
fi

if is there nvim; then
    alias vi=nvim
    alias vim=nvim
    export EDITOR=nvim
else
    export EDITOR=vim
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias ls='ls --color=auto'
alias s='source ~/.bashrc && source ~/.bash_profile'

alias tm='tmux'
alias tmls='tmux ls'
alias tmas='tmux attach-session -t'
alias tmks='tmux kill-session -t'
alias tmkp='tm kill-pane'
alias tmd='tmux detach'
alias tmns='tmux new-session'
alias nv='nvim'
alias cdr='cd $(git root)'

ptest() (
  npm run test "$1" -- --headed --project=chromium "${@/.ts/.js}"
)

gcp_ssh_username=dhogan_maxmind_com
export gcp_ssh_username

export PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dallas/google-cloud-sdk/path.bash.inc' ]; then . '/Users/dallas/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dallas/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/dallas/google-cloud-sdk/completion.bash.inc'; fi

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# MM aliases
alias template='./dev/bin/web/generate-go-default-layout.sh -g'
alias submit='./dev/bin/general/submit-work.sh'
alias dw='dev/bin/web/dev-website'
alias prove-this='dev/bin/test/prove-this'
alias ptg='precious tidy --git'
alias pts='precious tidy --staged'
alias plg='precious lint --git'
alias pls='precious lint --staged'

eval "$(oh-my-posh prompt init bash --config ~/.config/oh-my-posh/themes/theme.omp.json)"

