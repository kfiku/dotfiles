#!/bin/bash

# you need python 3 and pip install keybind

export KEYBINDER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PID=$(ps aux | grep keybinder.py | grep -v grep)

if [[ ! -z "$PID" ]]; then
  echo "keybinder.py already working"
  echo "$PID"
else
  python3 "$KEYBINDER_DIR"/keybinder.py
fi