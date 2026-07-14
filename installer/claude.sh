#!/usr/bin/env bash

set -eux

# Install Claude CLI globally (works on both macOS and Linux/devcontainer).
#
# Health check uses `claude --version`, not `command -v claude`: a broken or
# incomplete install (e.g. a launcher symlink whose native binary was never
# downloaded) still satisfies `command -v` but fails to run. Checking that it
# actually executes ensures a broken install gets repaired rather than skipped.
if claude --version >/dev/null 2>&1; then
	echo "Claude CLI is already installed ($(claude --version))"
	exit 0
fi

# Remove any stale/broken launcher so it can't shadow the new install.
rm -f "$HOME/.local/bin/claude"

# Prefer the native installer: it ships a standalone binary and avoids the
# npm/pnpm optional-dependency + postinstall pitfalls that can leave the
# platform-native binary undownloaded (--omit=optional, --ignore-scripts,
# pnpm's default script blocking).
curl -fsSL https://claude.ai/install.sh | bash

# Ensure the install dir is on PATH for this shell and verify it runs.
export PATH="$HOME/.local/bin:$PATH"
hash -r
claude --version
