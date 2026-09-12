#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  if ! command -v tailscale >/dev/null 2>&1; then
    curl -fsSL https://tailscale.com/install.sh | sh
  fi
  sudo systemctl enable --now tailscaled
}

check() {
  command -v tailscale >/dev/null 2>&1 &&
    systemctl is-enabled tailscaled >/dev/null 2>&1 &&
    systemctl is-active tailscaled >/dev/null 2>&1
}

provision "$@"
