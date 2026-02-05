#!/usr/bin/env bash

set -eux

# Install Claude CLI globally (works on both macOS and Linux/devcontainer)
if command -v npm >/dev/null 2>&1; then
	if command -v claude >/dev/null 2>&1; then
		echo "Claude CLI is already installed ($(claude --version 2>/dev/null || echo 'version unknown'))"
	else
		NPM_PREFIX=$(npm config get prefix)
		mkdir -p "$NPM_PREFIX/lib/node_modules" "$NPM_PREFIX/bin"
		if [ -w "$NPM_PREFIX/lib/node_modules" ] && [ -w "$NPM_PREFIX/bin" ]; then
			npm install -g @anthropic-ai/claude-code
		else
			sudo env PATH="$PATH" npm install -g @anthropic-ai/claude-code
		fi
	fi
else
	echo "ERROR: npm not found - cannot install Claude CLI"
	echo "Ensure Node.js is installed (via mise, nvm, or system package)"
	exit 1
fi
