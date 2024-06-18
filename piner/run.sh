#!/bin/bash

# sudo apt-get install -y wmctrl

BITRIX=$(wmctrl -l | grep -i 'Bitrix' | awk '{print $1}')
SKYPE=$(wmctrl -l | grep -i 'Skype' | awk '{print $1}')
VSCODE=$(wmctrl -l | grep -i 'Visual Studio Code' | awk '{print $1}')

echo "
BITRIX: $BITRIX
SKYPE:  $SKYPE
VSCODE: $VSCODE
"

wmctrl -i -r "$BITRIX" -t 0
wmctrl -i -r "$SKYPE" -t 0

for item in $VSCODE; do
  wmctrl -i -r "$item" -t 0
done