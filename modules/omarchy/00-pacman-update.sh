#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  sudo env OMARCHY_ALLOW_DIRECT_PACMAN=1 pacman -Sy
}

check() {
  # Avoid redundant syncs if database was refreshed recently (within 1 day)
  [ -d /var/lib/pacman/sync ] && [ -n "$(find /var/lib/pacman/sync -maxdepth 1 -name "*.db" -mtime -1 2>/dev/null)" ]
}

provision "$@"
