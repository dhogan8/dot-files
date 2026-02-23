#!/bin/bash

echo 'git config'

PREFIX="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Remove sections now managed by gitconfig-shared to avoid stale duplicates
for section in alias branch color push core delta diff interactive 'filter "lfs"'; do
  git config --global --remove-section "$section" 2>/dev/null || true
done

# Include shared config (aliases, delta, colors, lfs, etc.)
git config --global include.path "$PREFIX/gitconfig-shared"

# Environment-specific settings
if [ "$(uname)" == "Darwin" ]; then
  git config --global user.name 'Dallas Hogan'
  git config --global user.email 'dallastar4@gmail.com'
  git config --global github.user dhogan8
else
  git config --global user.name 'Dallas Hogan'
  # Devcontainer email/github are set by the repo's .gitconfig or environment
fi
