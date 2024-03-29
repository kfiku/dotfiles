#!/bin/bash

PROJECT_KEY=$1

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PROJECT=$(grep -E "^$PROJECT_KEY" "$CURRENT_DIR"/projects_map.list | head -n 1)
if [ ! -z "$PROJECT" ]; then
   EDITOR=$(echo "$PROJECT" | awk '{print $3}')
   DIR=$(echo "$PROJECT" | awk '{print $5}')

   echo "$EDITOR \"$DIR\""

   $EDITOR "$DIR"
fi
