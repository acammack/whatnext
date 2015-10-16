#!/bin/bash

source whatnext

_whatnext() {
  local cur action project

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  action=${COMP_WORDS[1]}
  project=${COMP_WORDS[2]}

  case $COMP_CWORD in
    1)
      COMPREPLY=( $( compgen -W 'add queue start finish list open echo' -- $cur ) )
      ;;
    2)
      COMPREPLY=( $( compgen -W "$(ls $WN_PROJECTS_DIRECTORY)" -- $cur ) )
      ;;
    3)
      case "$action" in
        queue)
          COMPREPLY=( $( compgen -W "$(ls $WN_PROJECTS_DIRECTORY/$project)" -- $cur ) )
          ;;
        start)
          COMPREPLY=( $( compgen -W "$(ls $WN_ACTIVE_DIRECTORY/$project)" -- $cur ) )
          ;;
        *) COMPREPLY=()
      esac
      ;;
    *) COMPREPLY=()
  esac

}

complete -o filenames -F _whatnext whatnext
