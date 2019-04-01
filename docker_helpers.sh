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
complete -F _docker_bash -o nospace d_i d_e d_b d_ngx_r d_rm
