#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../utils.sh"


declare -A packages
packages=( \
  ["lf"]="gokcehan/lf" \
  ["gotetris"]="jjinux/gotetris" \
  ["lazygit"]="jesseduffield/lazygit" \
  ["lazydocker"]="jesseduffield/lazydocker" \
  ["gotop"]="xxxserxxx/gotop/cmd/gotop"
)

GOPATH=${GOPATH:-$HOME/go}

run() {
  for pkg in "${packages[@]}"
  do
    go get "github.com/$pkg"
  done
}

check() {
  for exe in "${!packages[@]}"
  do
    [ -x "$GOPATH/bin/$exe" ] || return 1
  done
}

provision "$@"
