#!/usr/bin/env bash

set -eux

# Install Claude CLI globally
if command -v npm >/dev/null 2>&1; then
	npm install -g @anthropic-ai/claude-code
else
	echo "npm not found - skipping Claude CLI installation"
fi
