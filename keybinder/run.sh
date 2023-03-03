#!/bin/bash

# you need python 3 and pip install keybind

export KEYBINDER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PROCCESS=$(ps aux | grep keybinder.py | grep -v grep)

if [[ ! -z "$PROCCESS" ]]; then
  echo "keybinder.py already working"
  echo "$PROCCESS"

  if [[ "$1" == "restart" ]]; then
    PID=$(echo "$PROCCESS" | awk '{ print $2 } ')

    echo "killing keybinder on PID: $PID"

    if [[ -n "$PID" ]]; then
      kill "$PID"
    fi
  else
    echo "Run with:"
    echo ' '
    echo '```'
    echo "$0 restart"
    echo '```'
    echo ' '
    echo "to restart keybinder"
  fi
fi

if [[ "$1" == "restart" ]]; then

  python3 "$KEYBINDER_DIR"/keybinder.py &
  echo "Keybinder started"
fi