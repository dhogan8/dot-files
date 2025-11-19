#!/usr/bin/env bash

set -eux

# Install Claude CLI globally
if command -v npm >/dev/null 2>&1; then
	# Check if claude is already installed
	if command -v claude >/dev/null 2>&1; then
		echo "Claude CLI is already installed ($(claude --version 2>/dev/null || echo 'version unknown'))"
		# Optionally uncomment the next line to always update to latest version
		# echo "Run 'npm update -g @anthropic-ai/claude-code' to update"
	else
		# Check if we need sudo for global npm installs
		NPM_PREFIX=$(npm config get prefix)
		if [ -w "$NPM_PREFIX/lib/node_modules" ] && [ -w "$NPM_PREFIX/bin" ]; then
			# We have write permissions, install without sudo
			npm install -g @anthropic-ai/claude-code
		else
			# Need elevated permissions
			echo "Installing Claude CLI globally (requires sudo)..."
			sudo npm install -g @anthropic-ai/claude-code
		fi
	fi
else
	echo "npm not found - skipping Claude CLI installation"
fi
