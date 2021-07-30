#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"
version=${PYTHON_VERSION:-3.9.5}
prefix=${PYTHON_PREFIX:-/usr/local}


run() {
  sudo PYTHON_CONFIGURE_OPTS="--enable-shared" python-build "$version" "$prefix"
}


check() {
  "$prefix/bin/python3" -c "import sys; print(sys.version)" 2>&1 | grep -q "$version"
}


provision "$@"
