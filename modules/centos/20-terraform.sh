#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"
version=0.12.20

run() {
  cd /tmp || exit 1
  curl -OL "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip"
  unzip -o terraform_${version}_linux_amd64.zip
  sudo mv terraform /usr/local/bin
}


check() {
  terraform version 2>&1 | grep -q "Terraform v${version}"
}


provision "$@"
