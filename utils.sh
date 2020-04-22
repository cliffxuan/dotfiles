#!/usr/bin/env bash
get_os() {
  if [ -f /etc/os-release ]; then
      # freedesktop.org and systemd
      . /etc/os-release
      OS=$NAME
      VER=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
      # linuxbase.org
      OS=$(lsb_release -si)
      VER=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
      # For some versions of Debian/Ubuntu without lsb_release command
      # shellcheck source=/dev/null
      . /etc/lsb-release
      OS=$DISTRIB_ID
      VER=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
      # Older Debian/Ubuntu/etc.
      OS=Debian
      VER=$(cat /etc/debian_version)
  elif [ -f /etc/SuSe-release ]; then
      # Older SuSE/etc.
      ...
  elif [ -f /etc/redhat-release ]; then
      # Older Red Hat, CentOS, etc.
      ...
  else
      # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
      OS=$(uname -s)
      VER=$(uname -r)
  fi
  export OS VER
}


provision() {
  local module=$0
  local msg=${1:-"already provisioned. do nothing!"}
  setup_logging
  if check >&4 2>&1
  then
    echo "'$module' $msg"
  else
    echo "'$module' has not been applied. applying..."
    if [ "$VERBOSE" = true ]
    then
      run >&4 2>&1
    else
      run >&4 2>&1 &
      show_spinner $!
    fi
    if check >&4 2>&1
    then
      echo succeed! 
    else
      echo fail! >&2
    fi
  fi
}


setup_logging() {
  if [ -z "$LOG_PATH" ]
  then
    seed="$(date "+%Y%m%d%H%M%S").$$"
    export LOG_PATH="/tmp/install.${seed}.log"
  fi
  if ! { true >&4; } 2<> /dev/null
  then
    exec 4<> "$LOG_PATH" # open the log file at fd 4
    if [ "$VERBOSE" = true ]
    then
      echo "verbose mode on"
      tail -f "$LOG_PATH" &
      tail_pid=$!
      trap 'kill $tail_pid' SIGINT SIGTERM EXIT
    fi
  fi
}


run_sh_scripts() {
  local script_dir=$1
  for script in $(find "$script_dir" -maxdepth 1 -type f -name "*.sh" -exec basename {} \; | sort | grep -Ev '^_')
  do
    echo "========= run install $script_dir/$script"
    "$script_dir/$script"
  done
}


show_spinner()
{
  local -r pid="${1}"
  local -r delay='0.75'
  local spinstr='\|/-'
  local temp
  while ps a | awk '{print $1}' | grep -q "${pid}"; do
    temp="${spinstr#?}"
    printf " [%c]  " "${spinstr}"
    spinstr=${temp}${spinstr%"${temp}"}
    sleep "${delay}"
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}
