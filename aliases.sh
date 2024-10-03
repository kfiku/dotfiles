#!/bin/bash

# some aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -lah'
alias sm='sudo mc'
alias cip='ip a l | grep -ohE "inet [0-9.]+" | grep -ohE "[0-9.]+" | grep -vE "^(127|172)"'
alias rs='killall gnome-shell'

# php composer
alias c='composer'
alias s='php app/console'

# sublimes
alias e='code'
alias se='sudo code'

alias ea="e $DOTFILES_DIR/aliases.sh"
alias eg="e $DOTFILES_DIR/git_helpers.sh"
alias eap="e $DOTFILES_DIR/aliases_private.sh"
alias ef="e $DOTFILES_DIR/functions.sh"
alias eg="e $DOTFILES_DIR/git_helpers.sh"
alias ec="e ~/.ssh/config"
alias eh="e /etc/hosts"
alias ed="e $DOTFILES_DIR"
alias r="sudo service nginx restart"
alias en="e /etc/nginx/conf.d/casino.conf"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
