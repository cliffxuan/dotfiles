#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=./utils.sh
source "$DIR/utils.sh"

run_os_specific_scripts() {
  get_os  # set $OS
  echo "========= operating system $OS"
  shopt -s nocasematch
  local script_dir
  if [[ $OS =~ ubuntu  ]]
  then
    script_dir=$DIR/modules/ubuntu
  elif [[  $OS =~ centos ]]
  then
    script_dir=$DIR/modules/centos
  else
    echo "\$OS=$OS does not have os specific packages"
  fi
  [ -n "$script_dir" ] && run_sh_scripts "$script_dir"
}


run_common_scripts() {
  run_sh_scripts "$DIR/modules"
}


VERBOSE=false
while getopts ":v" opt
do
    case "$opt" in
        v)
            VERBOSE=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

setup_logging
run_os_specific_scripts
run_common_scripts
