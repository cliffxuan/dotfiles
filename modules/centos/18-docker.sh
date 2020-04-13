#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo yum install -y docker-ce docker-ce-cli containerd.io
}


check() {
  docker version 2>&1 | grep -qE "Version: +19."
}


provision "$@"
