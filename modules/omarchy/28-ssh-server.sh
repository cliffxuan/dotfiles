#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$DIR/../../utils.sh"

packages=(
  openssh
  xorg-xauth
)

run() {
  sudo env OMARCHY_ALLOW_DIRECT_PACMAN=1 pacman -S --noconfirm --needed "${packages[@]}"

  # Ensure X11 forwarding drop-in config exists
  sudo mkdir -p /etc/ssh/sshd_config.d
  echo "X11Forwarding yes" | sudo tee /etc/ssh/sshd_config.d/20-x11.conf >/dev/null
  sudo chmod 644 /etc/ssh/sshd_config.d/20-x11.conf

  # Enable and start sshd service
  sudo systemctl enable --now sshd

  # Reload or restart sshd to apply changes if running
  if systemctl is-active sshd >/dev/null 2>&1; then
    sudo systemctl reload sshd || sudo systemctl restart sshd
  fi
}

check() {
  pacman -Q "${packages[@]}" >/dev/null 2>&1 &&
    [ -f /etc/ssh/sshd_config.d/20-x11.conf ] &&
    grep -q "^[[:space:]]*X11Forwarding[[:space:]]\+yes" /etc/ssh/sshd_config.d/20-x11.conf &&
    systemctl is-enabled sshd >/dev/null 2>&1 &&
    systemctl is-active sshd >/dev/null 2>&1
}

provision "$@"
