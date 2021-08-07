#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

packages="virtualenv virtualenvwrapper pipenv flake8 black httpie pynvim autoflake"

run() {
  for pkg in $packages
  do
    pip3 install "$pkg"
  done
}

check() {
  for pkg in $packages
  do
    python3 -c "import $pkg" 2>/dev/null || return 1
  done
}

provision "$@"
