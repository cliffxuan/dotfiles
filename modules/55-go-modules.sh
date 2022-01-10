#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"


declare -A packages
packages=( \
  ["lf"]="gokcehan/lf" \
  ["lazygit"]="jesseduffield/lazygit" \
  ["bt"]="cliffxuan/bt" \
  ["lazydocker"]="jesseduffield/lazydocker"
)

GOPATH=${GOPATH:-$HOME/go}

run() {
  for pkg in "${packages[@]}"
  do
    go install "github.com/$pkg@latest"
  done
}

check() {
  for exe in "${!packages[@]}"
  do
    [ -x "$GOPATH/bin/$exe" ] || return 1
  done
}

provision "$@"
