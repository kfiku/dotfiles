#!/bin/bash
export LD_PRELOAD=/usr/lib/libgtk4-layer-shell.so
python /home/grzegorz/Dropbox/dotfiles/guides/guides.py "$@"