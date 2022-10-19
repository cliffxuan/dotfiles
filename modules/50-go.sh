#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

get_os # set $OS
if [[ $OS =~ Darwin ]]; then
  format="darwin-amd64"
elif dpkg --print-architecture | grep -q arm64; then
  format="linux-arm64"
else
  format="linux-amd64"
fi

if [ -n "$GO_VERSION" ]; then
  version=$GO_VERSION
else
  version=$(grep -Po '(?<=href=")(/dl/go.*)(?=">)' /tmp/go-dl.html | grep $format | head -1 | grep -Po "(?<=go)([0-9]*\.[0-9]*\.[0-9]*)")
fi

if [ -z "$version" ]; then
  echo "failed to find latest go version"
  exit 0
else
  echo "version=$version"
fi

run() {
  cd /tmp || return 1
  curl -OL "https://dl.google.com/go/go${version}.${format}.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go${version}.${format}.tar.gz"
  sudo ln -fs /usr/local/go/bin/go /usr/local/bin
  sudo ln -fs /usr/local/go/bin/gofmt /usr/local/bin/gofmt
}

check() {
  go version 2>&1 | grep -q "go version go$version"
}

provision "$@"
