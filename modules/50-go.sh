#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

get_os  # set $OS
if [[ $OS =~ Darwin ]]; then
  format="darwin-amd64"
else
  format="linux-amd64"
fi

version=${GO_VERSION:-1.16.5}
run() {
  cd /tmp || return 1
  curl -OL "https://dl.google.com/go/go${version}.${format}.tar.gz"
  sudo tar -C /usr/local -xzf "go${version}.${format}.tar.gz"
  sudo ln -s /usr/local/go/bin/go /usr/local/bin
  sudo ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt
}

check() {
  go version 2>&1 | grep -q "go version go$version"
}


provision "$@"
