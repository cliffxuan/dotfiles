#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  sh <(curl -L https://nixos.org/nix/install)
}

check() {
  local nix_sh="$HOME"/.nix-profile/etc/profile.d/nix.sh
  if [ -f "$nix_sh" ]
  then
    # shellcheck source=/dev/null
    source "$nix_sh"
    hash nix-env 2>&1
  else
    return 1
  fi
}

provision "$@"
