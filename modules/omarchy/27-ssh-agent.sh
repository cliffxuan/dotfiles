#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$DIR/../../utils.sh"

run() {
  # Enable and start OpenSSH user socket
  systemctl --user enable --now ssh-agent.socket

  # Ensure systemd user session environment has SSH_AUTH_SOCK set
  if [ -n "$XDG_RUNTIME_DIR" ]; then
    systemctl --user set-environment SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
  fi
  if command -v dbus-update-activation-environment >/dev/null 2>&1; then
    dbus-update-activation-environment --systemd SSH_AUTH_SOCK 2>/dev/null || true
  fi

  # Link environment.d configuration if present
  mkdir -p "$HOME/.config/environment.d"
  if [ -f "$CONFIG_DIR/environment.d/ssh-agent.conf" ]; then
    ln -sf "$CONFIG_DIR/environment.d/ssh-agent.conf" "$HOME/.config/environment.d/ssh-agent.conf"
  fi
}

check() {
  systemctl --user is-enabled ssh-agent.socket >/dev/null 2>&1 &&
    systemctl --user is-active ssh-agent.socket >/dev/null 2>&1 &&
    [ -f "$HOME/.config/environment.d/ssh-agent.conf" ]
}

provision "$@"
