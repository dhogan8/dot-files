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

add_path "$HOME/.vim/plugged/fzf/bin"

[ -f "$HOME"/.vim/plugged/fzf/shell/key-bindings.bash ] && . "$HOME"/.vim/plugged/fzf/shell/key-bindings.bash
[ -f "$HOME"/.vim/plugged/fzf/shell/completion.bash ] && . "$HOME"/.vim/plugged/fzf/shell/completion.bash
[ -f "$HOME"/dot-files/local_bashrc ] && . "$HOME"/dot-files/local_bashrc

add_path "$HOME/local/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f 'Users/dallas/google-cloud-sdk/path.bash.inc' ]; then . '/Users/dallas/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dallas/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/dallas/google-cloud-sdk/completion.bash.inc'; fi

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

# https://raim.codingfarm.de/blog/2013/01/30/tmux-update-environment/
tmux() {
	#set -eux
	local tmux=$(type -fp tmux)

	if [ $# -ge 1 ] && [ -n "$1" ]; then
		case "$1" in
		update-environment | update-env | ue)
			local v
			while read v; do
				if [[ $v == -* ]]; then
					echo "unset $v"
					unset ${v/#-/}
				else
					# Add quotes around the argument
					v=${v/=/=\"}
					v=${v/%/\"}
					echo "export $v"
					eval export "$v"
				fi
			done < <(tmux show-environment)
			;;
		# https://gist.github.com/marczych/10524654
		ns)
			tmux_session_name
			tmux rename-session "$SESSION_NAME"
			;;
		*)
			$tmux "$@"
			;;
		esac
	else
		tmux_session_name
		$tmux new -s "$SESSION_NAME"
	fi
}

# shellcheck disable=SC2046

export PROMPT_COMMAND="_omp_hook; history -a"
export PATH
