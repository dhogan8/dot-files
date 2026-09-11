#!/usr/bin/env bash

set -eux

# Install workmux (https://github.com/raine/workmux) on both macOS and Linux.
#
# Pin the install dir to ~/.local/bin. The official installer otherwise prefers
# /usr/local/bin when writable, which would put the binary at a location that is
# LATER on PATH than ~/.local/bin and get shadowed. Pinning keeps a single copy
# in the dir that is first on PATH, where `workmux update` can refresh it later.
export WORKMUX_INSTALL_DIR="$HOME/.local/bin"

# Health check runs the binary rather than `command -v`: a partial install still
# satisfies `command -v` but fails to execute. Running it ensures a broken
# install gets repaired instead of skipped.
if workmux --version >/dev/null 2>&1; then
	echo "workmux is already installed ($(workmux --version))"
	exit 0
fi

curl -fsSL https://raw.githubusercontent.com/raine/workmux/main/scripts/install.sh | bash

# Ensure the install dir is on PATH for this shell and verify it runs.
export PATH="$WORKMUX_INSTALL_DIR:$PATH"
hash -r
workmux --version
