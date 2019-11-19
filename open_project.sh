#!/bin/bash

set -x

PROJECT_KEY=$1

echo $PROJECT_KEY

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PROJECT=$(grep "$PROJECT_KEY" "$CURRENT_DIR"/projects_map.list | head -n 1)
if [ ! -z "$PROJECT" ]; then
   EDITOR=$(echo "$PROJECT" | awk '{print $3}')
   DIR=$(echo "$PROJECT" | awk '{print $5}')

   $EDITOR "$DIR"
fi
