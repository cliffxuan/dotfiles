#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"
version=${PYTHON_VERSION:-3.11.0}
prefix=${PYTHON_PREFIX:-$HOME/.pyenv/versions/$version}
python_build="$HOME/.pyenv/plugins/python-build/bin/python-build"


run() {
  mkdir -p "$prefix"
  sudo PYTHON_CONFIGURE_OPTS="--enable-shared" $python_build "$version" "$prefix"
}


check() {
  [[ -f "$prefix/bin/python3" ]] && "$prefix/bin/python3" -c "import sys; print(sys.version)" 2>&1 | grep -q "$version"
}


provision "$@"
