#!/bin/bash

source whatnext

_whatnext() {
  local cur action project project_dir active_dir

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  action=${COMP_WORDS[1]}
  project=${COMP_WORDS[2]}

  case $COMP_CWORD in
    1)
      COMPREPLY=( $( compgen -W 'add queue start finish tree ls open echo' -- "$cur" ) )
      ;;
    2)
      COMPREPLY=( $( compgen -W "$(ls --quoting-style=escape "$WN_PROJECTS_DIRECTORY")" -- "$cur" ) )
      ;;
    3)
      project_dir="$WN_PROJECTS_DIRECTORY/$project"
      active_dir="$WN_ACTIVE_DIRECTORY/$project"
      case "$action" in
        queue)
          pushd $project_dir >/dev/null
          # From the bash-completion package
          _filedir
          popd >/dev/null
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
          ;;
        start)
          pushd $active_dir >/dev/null
          # From the bash-completion package
          _filedir
          popd >/dev/null
          ;;
        open)
          pushd $project_dir >/dev/null
          # From the bash-completion package
          _filedir
          popd >/dev/null
          ;;
        *) COMPREPLY=()
      esac
      ;;
    *) COMPREPLY=()
  esac

}

complete -F _whatnext whatnext
