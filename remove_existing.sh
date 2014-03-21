#!/bin/bash

if [ -d "$HOME/.opam/system/lib/corejs" ]; then
  rm -r $HOME/.opam/system/lib/corejs
fi
