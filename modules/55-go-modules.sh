#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

declare -A packages
packages=(
  ["lf"]="github.com/gokcehan/lf"
  ["lazygit"]="jgithub.com/esseduffield/lazygit"
  ["bt"]="github.com/cliffxuan/bt"
  ["lazydocker"]="github.com/jesseduffield/lazydocker"
  ["shfmt"]="mvdan.cc/sh/v3/cmd/shfmt"
)

GOPATH=${GOPATH:-$HOME/.go}

run() {
  for pkg in "${packages[@]}"; do
    go install "$pkg@latest"
  done
}

check() {
  for exe in "${!packages[@]}"; do
    [ -x "$GOPATH/bin/$exe" ] || return 1
  done
}

provision "$@"
