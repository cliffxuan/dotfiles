#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"
# shellcheck source=/dev/null
source "$HOME/.nix-profile/etc/profile.d/nix.sh"

packages="bat tmux ripgrep fd ctags inotify-tools shellcheck tree delta jq fzf"

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
  for pkg in $packages
  do
    get_executable "$pkg"
    hash "$executable" 2>/dev/null || nix-env -f '<nixpkgs>' -iA "$pkg"
  done
}

check() {
  for pkg in $packages
  do
    get_executable "$pkg"
    hash "$executable" 2>/dev/null || return 1
  done
}


provision "$@"
