#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"
# shellcheck source=/dev/null
source "$HOME/.nix-profile/etc/profile.d/nix.sh"

get_executable() {
  local pkg=$1
  case $pkg in
    "inotify-tools")
      executable=inotifywait
      ;;
    "ripgrep")
      executable=rg
      ;;
    *)
      executable=$pkg
      ;;
  esac
  export executable
}

run() {
  nix-env -i -f '<nixpkgs>' -E 'pkgs: (pkgs {}).ghc.withPackages (hp: with hp; [ zlib ])'
}

check() {
  hash ghc 2>/dev/null || return 1
}


provision "$@"
