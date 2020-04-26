#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

version=1.14.2
run() {
  cd /tmp || return 1
  curl -OL "https://dl.google.com/go/go${version}.linux-amd64.tar.gz"
  sudo tar -C /usr/local -xzf "go${version}.linux-amd64.tar.gz"
  sudo ln -s /usr/local/go/bin/go /usr/local/bin
  sudo ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt
}

check() {
  go version 2>&1 | grep -q "go version go$version linux/amd64"
}


provision "$@"
