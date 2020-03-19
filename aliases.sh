# some aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -lah'
alias sm='sudo mc'
alias cip='ifconfig eth0 | grep -ohE "inet [0-9.]+" | grep -ohE "[0-9.]+"'

# php composer
alias c='composer'
alias s='php app/console'

# sublimes
alias e='subl'
alias se='sudo subl'

alias ea='e ~/dotfiles/aliases.sh'
alias eg='e ~/dotfiles/git_helpers.sh'
alias eap='e ~/dotfiles/aliases_private.sh'
alias ef='e ~/dotfiles/functions.sh'
alias eg='e ~/dotfiles/git_helpers.sh'
alias ec='e ~/.ssh/config'
alias eh='e /etc/hosts'
alias r='sudo service nginx restart'
alias en='e /etc/nginx/conf.d/casino.conf'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
