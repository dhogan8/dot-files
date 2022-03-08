#!/bin/bash

set -eux

brew install go

brew tap jandedobbeleer/oh-my-posh
brew install oh-my-posh

git config --global alias.doms 'diff -w -M origin/main...HEAD --stat --name-only'
