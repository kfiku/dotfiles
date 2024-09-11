#!/bin/bash

alias gc='git checkout'
alias gcm='git checkout master'
alias gca='git commit --amend --no-edit'

alias gp='git pull'
alias gpr='git pull --rebase'
alias gpm='git pull origin master' # merge with master
alias gbr='grb' # git brach reset

alias gbl='git branch -v -a' # branches list with details

alias gst='git stash --include-untracked' # git stash all
alias gstp='git stash pop' # git stash all


# SHOW AVAILABLE GIT REPOS
alias gr='ssh $GIT_HOST -p $GIT_PORT 2>/dev/null | grep " R" --color=none'

function setup() {
  git config --global user.name "Grzegorz Klimek"
  git config --global user.email "grzegorz@e-gaming.cz"
  git config --global core.excludesFile /home/grzegorz/Dropbox/dotfiles/.gitignore
}

# checkout to remote branch
function gcr() {
    if git branch | grep "$1"
    then
        git checkout "$1"
    else
        echo git checkout -b "$1" origin/"$1"
        git checkout -b "$1" origin/"$1"
    fi
}

# reload current branch (remove curren, get new from remote)
function grb() {
  FORCE_REMOVE=1
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

  if [[ "${CURRENT_BRANCH}" == "master" ]]; then
    echo "Cannot reset '$CURRENT_BRANCH' branch"

    return
  fi

  echo "Reseting branch '$CURRENT_BRANCH' to fix merge conflicts (branch rebased)"

  if [[ -n "${FORCE_REMOVE}" ]]; then
    echo "FORCE RESETING"
  fi


  git checkout master
  git pull

  if [[ -n "${FORCE_REMOVE}" ]]; then
    git branch -D "$CURRENT_BRANCH"
  else
    git branch -d "$CURRENT_BRANCH"
  fi

  if git branch | grep "$CURRENT_BRANCH"; then
    echo "Branch '$CURRENT_BRANCH' is still in the repositiory please delete if first"

    return
  fi

  echo "Checkouting to fresh branch $CURRENT_BRANCH"
  gcr "$CURRENT_BRANCH"
}

# sync repo, clean old branches
function gs() {
    FORCE_REMOVE=1
    git fetch --all --prune
    git pull
    git remote prune origin
    git fetch origin

    if [[ $(git rev-parse --abbrev-ref HEAD) != "master" ]]; then
      git fetch origin master:master
    fi

    grgb "$FORCE_REMOVE"
}

function gspr() {
    git stash --include-untracked
    git pull --rebase
    git stash pop
}

# remove gone branches
function grgb() {
    FORCE_REMOVE=$1
    for branch in `git branch -vv | grep ': gone]' | awk '{print $1}'`; do
        if [ "$FORCE_REMOVE" = "1" ]; then
            git branch -D $branch;
        else
            git branch -d $branch;
        fi
    done
}

# create branch from master
function gbfm() {
    git checkout master
    git pull
    git checkout -b "$1" master
}

# create branch from current bramch
function gbfc() {
    git branch "$1"
    git checkout "$1"
}

# Clone git repos from local git
function clone() {
    git clone "$GIT_URL"/"$1" "$2"
}

# HELPER to get autocompete of clone ids
_git_clone ()
{
  local cur

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  commandline=${COMP_LINE}
  commandlineArr=(${commandline})
  arg1=${commandlineArr[1]}

  nrOfArgs=$(grep -o " " <<< "$commandline" | wc -l)

  if [[ $nrOfArgs = 1 ]]; then
    # IF WE HAVE ONLY ONE ARGUMENT
    case "$cur" in
      *)
      COMPREPLY=( $( compgen -W "$(gr | awk '{print $NF}')" -- $cur ) );;
    esac
  fi

  return 0
}
complete -F _git_clone -o nospace clone

# HELPER to get autocompete of gcr ids
alias gbl_to_checkout='git branch -a | grep -v "origin/master" | grep -v "* " | sed -e "s;remotes\/origin\/;;"' # branches list to bcr
_git_checkout_remote ()
{
  local cur

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  commandline=${COMP_LINE}
  commandlineArr=(${commandline})
  arg1=${commandlineArr[1]}

  nrOfArgs=$(grep -o " " <<< "$commandline" | wc -l)

  if [[ $nrOfArgs = 1 ]]; then
    # IF WE HAVE ONLY ONE ARGUMENT
    case "$cur" in
      *)
      COMPREPLY=( $( compgen -W "$(gbl_to_checkout)" -- $cur ) );;
    esac
  fi

  return 0
}
complete -F _git_checkout_remote -o nospace gcr
