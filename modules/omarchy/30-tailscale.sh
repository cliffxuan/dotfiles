#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

packages=(
  tailscale
)

run() {
  sudo env OMARCHY_ALLOW_DIRECT_PACMAN=1 pacman -S --noconfirm --needed "${packages[@]}"

  # Enable and start tailscaled daemon
  sudo systemctl enable --now tailscaled
}

check() {
  pacman -Q "${packages[@]}" >/dev/null 2>&1 &&
    systemctl is-enabled tailscaled >/dev/null 2>&1 &&
    systemctl is-active tailscaled >/dev/null 2>&1
}

provision "$@"
