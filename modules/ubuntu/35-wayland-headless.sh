#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

packages=(
  sway
  wayland-utils
  wl-clipboard
)

run() {
  sudo apt-get -y install "${packages[@]}"

  # Ensure user is in video and render groups for DRM access
  for grp in video render; do
    if getent group "$grp" >/dev/null 2>&1; then
      sudo usermod -a -G "$grp" "$USER"
    fi
  done

  # Link sway headless config
  mkdir -p "$HOME/.config/sway"
  ln -sf "$CONFIG_DIR/sway/headless.conf" "$HOME/.config/sway/headless.conf"

  # Link systemd user service
  mkdir -p "$HOME/.config/systemd/user"
  ln -sf "$CONFIG_DIR/systemd/user/sway-headless.service" "$HOME/.config/systemd/user/sway-headless.service"

  # Enable lingering and start service
  loginctl enable-linger "$USER" 2>/dev/null || true
  systemctl --user daemon-reload
  systemctl --user enable --now sway-headless.service
}

check() {
  dpkg-query -W -f='${Status}' "${packages[@]}" 2>/dev/null | grep -qv "ok installed" && return 1

  [ -L "$HOME/.config/sway/headless.conf" ] &&
    [ -L "$HOME/.config/systemd/user/sway-headless.service" ] &&
    systemctl --user is-enabled sway-headless.service >/dev/null 2>&1 &&
    systemctl --user is-active sway-headless.service >/dev/null 2>&1
}

provision "$@"
