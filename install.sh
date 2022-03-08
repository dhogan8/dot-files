#!/bin/bash

set -eux

if [ “$(uname)” == “Darwin” ]; then
    brew install go

    brew tap jandedobbeleer/oh-my-posh
    brew install oh-my-posh
fi

git config --global alias.doms 'diff -w -M origin/main...HEAD --stat --name-only'
