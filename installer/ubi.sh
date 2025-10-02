#!/usr/bin/env bash

set -eux

in="$HOME/local/bin"
mkdir -p "$in"
export PATH="$in:$PATH"

if [[ ! "$(command -v curl)" && "$(command -v apt-get)" ]]; then
	if [[ ! "$(command -v sudo)" ]]; then
		apt-get update && apt-get install sudo --autoremove -y
	fi
	apt-get install curl --autoremove -y
fi

if [ ! "$(command -v "$in/ubi")" ]; then
	curl --silent --location \
		https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh |
		TARGET=$in sh
fi

# Install 'is' first so we can use it in maybe_install
"$in/ubi" --project oalders/is --in "$in"

# Now upgrade ubi if needed
if command -v is >/dev/null 2>&1 && is cli age "$in/ubi" gt 7 days; then
	"$in/ubi" --self-upgrade
fi

maybe_install() {
	local project
	local repo
	IFS='/' read -r project repo <<<"$1"
	if ! is there "$repo" || is cli age "$repo" gt 7 days; then
		"$in/ubi" --project "$project/$repo" --in "$in"
	fi
}

maybe_install crate-ci/typos
maybe_install houseabsolute/omegasort
maybe_install houseabsolute/precious
maybe_install jqlang/jq
maybe_install junegunn/fzf

if is os name eq darwin; then
	if is cli version bat ne 0.24.0 || true; then
		ubi --in "$in" \
			--url https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-v0.23.0-x86_64-apple-darwin.tar.gz
	fi
else
	ubi --project sharkdp/bat --in "$in"
fi

if ! is there gh || is cli age gh gt 7 days; then
	ubi --project cli/cli --in "$in" --exe gh
fi

if ! is there delta; then
	cd /tmp || exit
	curl -O -L https://github.com/dandavison/delta/releases/download/0.17.0/git-delta-musl_0.17.0_amd64.deb
	sudo dpkg -i git-delta-musl_0.17.0_amd64.deb
fi

exit
