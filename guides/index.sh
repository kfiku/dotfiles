#!/bin/bash
export LD_PRELOAD=/usr/lib/libgtk4-layer-shell.so

pid=$(ps aux | grep "guides.py" | grep -v grep | awk '{print $2}')

if [[ -n "$pid" ]]; then
  echo "pid: $pid"
  kill "$pid"
else 
  python /home/grzegorz/Dropbox/dotfiles/guides/guides.py
fi