export BASH_SILENCE_DEPRECATION_WARNING=1

# Bash completion
if [ -f /usr/local/etc/bash_completion ]; then
  # Temporarily disable 'set -u' to avoid unbound variable errors in bash_completion
  # Save current shell options
  _shell_opts=$-
  set +u
  . /usr/local/etc/bash_completion
  # Restore shell options if 'u' was set
  [[ $_shell_opts == *u* ]] && set -u
  unset _shell_opts
elif [ -f /etc/bash_completion ]; then
  _shell_opts=$-
  set +u
  . /etc/bash_completion
  [[ $_shell_opts == *u* ]] && set -u
  unset _shell_opts
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  _shell_opts=$-
  set +u
  . /usr/share/bash-completion/bash_completion
  [[ $_shell_opts == *u* ]] && set -u
  unset _shell_opts
fi

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
  # Use GNU coreutils instead of BSD versions
  add_path /opt/homebrew/opt/coreutils/libexec/gnubin
fi

if command -v nvim >/dev/null 2>&1; then
    alias vi=nvim
    alias vim=nvim
    export EDITOR=nvim
else
    export EDITOR=vim
fi

alias ls='ls --color=auto'
alias s='source ~/.bash_profile'

alias tm='tmux'
alias tmls='tmux ls'
alias tmas='tmux attach-session -t'
alias tmks='tmux kill-session -t'
alias tmkp='tm kill-pane'
alias tmd='tmux detach'
alias tmns='tmux new-session'
alias nv='nvim'
alias cdr='cd $(git root)'
alias mmdev='devpod ssh mmwebsite -- -L 8443:localhost:8443 -L 8080:localhost:8080 -N'

ptest() (
  npm run test "$1" -- --headed --project=chromium "${@/.ts/.js}"
)

pcro () (
  npm run test "$1" -- --project=chromium "${@/.ts/.js}"
)

gcp_ssh_username=dhogan_maxmind_com
export gcp_ssh_username

# Load nvm for login shells
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

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
alias dw='bash dev/bin/web/dev-website'
alias dwl='bash dev/bin/web/dev-website -fs'
alias prove-this='dev/bin/test/prove-this'
alias ptg='precious tidy --git'
alias pts='precious tidy --staged'
alias plg='precious lint --git'
alias pls='precious lint --staged'

eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/themes/theme.omp.json 2>/dev/null)"
PS1="${PS1:-\u@\h:\w\$ }"


# Created by `pipx` on 2025-09-22 13:12:03
export PATH="$PATH:/home/dhogan_maxmind_com/.local/bin"
