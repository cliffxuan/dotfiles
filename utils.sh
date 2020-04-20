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
  local msg=${1:-"already provisioned. do nothing!"}
  if check >&4 2>&1  # TODO bad file descriptor run script standalone
  then
    echo "$msg"
  else
    run >&4 2>&1
    check && echo succeed! || echo fail! >&2
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
