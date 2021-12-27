#!/bin/bash

alias d='docker'
alias dp='d ps'
alias db='d_b'
alias dl='d logs 2>&1'
alias dlt='d logs 2>&1 --tail 100000'
alias dt='d logs 2>&1 -f --tail 10'
alias di='d inspect'
alias d_s='d stats --format "table {{.Name}}\t{{.MemUsage}}\t{{.CPUPerc}}"'

alias ds='docker service'
alias dsi='ds inspect'
alias dsl='ds logs 2>&1'
alias dst='ds logs 2>&1 -f --tail 10'
alias dsi='ds inspect'
alias dsp='ds ps'
alias dsrm='ds rm'

alias dc='docker-compose'
alias dcu='dc up'

# Getting running services names
dsn () {
  ds ls | awk '{if (NR!=1) {print $2}}' | sort
}

dsls () {
  SERVICES=$(docker service ls --format 'table {{.Replicas}}\t{{.Name}}\t{{.Ports}}\t{{.Image}}' | grep -v '0/0')
  REPLICAS=$(echo "$SERVICES" | awk 'BEGIN { actual=0; wanted=0} { split($0,replicas,"/"); actual+=replicas[1]; wanted+=replicas[2]; } END {print actual "/" wanted}')
  SUM=$(echo "$SERVICES" | wc -l)

  echo "$SERVICES"
  echo -e "$REPLICAS\t\t\t$SUM"
  echo "$SERVICES" | grep -E '^0/.'
}

# Getting running containers names
d_n () {
  docker ps | awk '{if (NR!=1) {print $NF}}' | sort
}

# Getting running containers names and ips
d_ip () {
  for id in $(d_n)
  do
    name=$(docker inspect --format '{{ .Name }}' $id)
    ip=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $id)
    printf "%-40s %-20s\n" $id $ip
  done
}

# Inspect id
d_i () {
  docker inspect $1
}
# Exec id
d_e () {
  docker exec "$@"
}

# Go to bash of container id
d_b () {
  docker exec -it $1 bash || docker exec -it $1 sh
}

# Reload nginx in docker
d_ngx_r () {
  docker exec $1 nginx -s reload
}

# Remove container
d_rm () {
  docker rm -f $1
}



# HELPER to get autocompete of docker ids
_docker_bash ()
{
  local cur

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  commandline=${COMP_LINE}
  commandlineArr=(${commandline})
  arg1=${commandlineArr[1]}
  arg2=${commandlineArr[2]}

  nrOfArgs=$(grep -o " " <<< "$commandline" | wc -l)

  if [[ $nrOfArgs = 1 ]]; then
    # IF WE HAVE ONLY ONE ARGUMENT
    case "$cur" in
      *)
      COMPREPLY=( $( compgen -W "$(d_n)" -- $cur ) );;
    esac
  else
    last="${cur##*/}"
    dir=$(echo $cur | sed -e 's,'"$last"'$,,g')

    files=""
    for di in $(docker exec $arg1 ls -p $dir)
    do
      files=$files" $dir$di"
    done

    case "$cur" in
      *)
      COMPREPLY=( $( compgen -W "$files" -- $cur ) );;
    esac
  fi

  return 0
}
complete -F _docker_bash -o nospace d_i d_e d_b d_ngx_r d_rm db dl dlt di dt d_s

_docker_service_bash ()
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
      COMPREPLY=( $( compgen -W "$(dsn)" -- $cur ) );;
    esac
  fi

  return 0
}

complete -F _docker_service_bash -o nospace dsi dsl dst dsp dsrm