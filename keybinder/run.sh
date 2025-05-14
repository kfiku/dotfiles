#!/bin/bash

# you need python 3 and pip install keybind

export KEYBINDER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PROCCESS=$(ps aux | grep keybinder.py | grep -v grep)

if [[ ! -z "$PROCCESS" ]]; then
  echo "keybinder.py already working"
  echo "$PROCCESS"

  PID=$(echo "$PROCCESS" | awk '{ print $2 } ')

  echo "killing keybinder on PID: $PID"

  if [[ -n "$PID" ]]; then
    kill "$PID"
  fi

fi

python3 "$KEYBINDER_DIR"/keybinder.py &
python3 "$KEYBINDER_DIR"/clipper.py &
echo "Keybinder started"