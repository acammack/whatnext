#!/bin/bash

source whatnext

# $1: directory
# $2: -a to include hidden files on empty completion
_whatnext_file_search() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  pushd $1 >/dev/null

  # From the bash-completion package
  _filedir
  popd >/dev/null

  if [ ! "-a" == "$2" ]; then
    if [ ! "." == "${cur:0:1}" ]; then
      # For some reason ${array[@]//.*/} doesn't work here
      local x
      for x in "${!COMPREPLY[@]}"; do
        local d="${COMPREPLY[$x]}"
        if [ "." == "${d:0:1}" ]; then
          unset COMPREPLY[$x]
        fi
      done
    fi
  fi
}

_whatnext() {
  local cur action project project_dir active_dir

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  action=${COMP_WORDS[1]}
  project=${COMP_WORDS[2]}

  case $COMP_CWORD in
    1)
      COMPREPLY=( $( compgen -W 'add queue start finish open ls tree grep echo' -- "$cur" ) )
      ;;
    2)
      _whatnext_file_search $WN_PROJECTS_DIRECTORY
      ;;
    3)
      project_dir="$WN_PROJECTS_DIRECTORY/$project"
      active_dir="$WN_ACTIVE_DIRECTORY/$project"
      case "$action" in
        queue)
          _whatnext_file_search $project_dir
          ;;
        start)
          _whatnext_file_search $active_dir -a
          ;;
        open)
          _whatnext_file_search $project_dir -a
          ;;
        *) COMPREPLY=()
      esac
      ;;
    *) COMPREPLY=()
  esac

}

complete -F _whatnext whatnext
