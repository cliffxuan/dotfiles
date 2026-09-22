#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

packages=(
  sway
  wayland-utils
  wl-clipboard
  xwayland
  wayvnc
  novnc
  websockify
  python3-cryptography
  fuzzel
  grim
  slurp
  wtype
  xdotool
)

run() {
  sudo apt-get -y install "${packages[@]}"

  # Ensure user is in video and render groups for DRM access
  for grp in video render; do
    if getent group "$grp" >/dev/null 2>&1; then
      sudo usermod -a -G "$grp" "$USER"
    fi
  done

  # Link index.html to vnc.html in novnc if missing for convenient web root access
  if [ -d /usr/share/novnc ] && [ ! -e /usr/share/novnc/index.html ]; then
    sudo ln -sf vnc.html /usr/share/novnc/index.html
  fi

  # Default wayvnc config for local headless sway
  mkdir -p "$HOME/.config/wayvnc"
  if [ ! -f "$HOME/.config/wayvnc/config" ]; then
    cat <<EOF >"$HOME/.config/wayvnc/config"
address = 127.0.0.1
port = 5901
enable_auth = false
password = xuan
EOF
    chmod 600 "$HOME/.config/wayvnc/config"
  fi

  # Link vnc-auth-proxy helper script
  mkdir -p "$HOME/.local/bin"
  ln -sf "$SCRIPT_DIR/vnc-auth-proxy" "$HOME/.local/bin/vnc-auth-proxy"

  # Link sway headless config
  mkdir -p "$HOME/.config/sway"
  ln -sf "$CONFIG_DIR/sway/headless.conf" "$HOME/.config/sway/headless.conf"

  # Link systemd user services
  mkdir -p "$HOME/.config/systemd/user"
  ln -sf "$CONFIG_DIR/systemd/user/sway-headless.service" "$HOME/.config/systemd/user/sway-headless.service"
  ln -sf "$CONFIG_DIR/systemd/user/wayvnc.service" "$HOME/.config/systemd/user/wayvnc.service"
  ln -sf "$CONFIG_DIR/systemd/user/novnc.service" "$HOME/.config/systemd/user/novnc.service"
  ln -sf "$CONFIG_DIR/systemd/user/vnc-auth-proxy.service" "$HOME/.config/systemd/user/vnc-auth-proxy.service"

  # Enable lingering and start services
  loginctl enable-linger "$USER" 2>/dev/null || true
  systemctl --user daemon-reload
  systemctl --user enable --now sway-headless.service
  systemctl --user enable --now wayvnc.service
  systemctl --user enable --now novnc.service
  systemctl --user enable --now vnc-auth-proxy.service
}

check() {
  dpkg-query -W -f='${Status}' "${packages[@]}" 2>/dev/null | grep -qv "ok installed" && return 1

  [ -f "$HOME/.config/wayvnc/config" ] &&
    [ -L "$HOME/.local/bin/vnc-auth-proxy" ] &&
    [ -L "$HOME/.config/sway/headless.conf" ] &&
    [ -L "$HOME/.config/systemd/user/sway-headless.service" ] &&
    [ -L "$HOME/.config/systemd/user/wayvnc.service" ] &&
    [ -L "$HOME/.config/systemd/user/novnc.service" ] &&
    [ -L "$HOME/.config/systemd/user/vnc-auth-proxy.service" ] &&
    systemctl --user is-enabled sway-headless.service >/dev/null 2>&1 &&
    systemctl --user is-active sway-headless.service >/dev/null 2>&1 &&
    systemctl --user is-enabled wayvnc.service >/dev/null 2>&1 &&
    systemctl --user is-active wayvnc.service >/dev/null 2>&1 &&
    systemctl --user is-enabled novnc.service >/dev/null 2>&1 &&
    systemctl --user is-active novnc.service >/dev/null 2>&1 &&
    systemctl --user is-enabled vnc-auth-proxy.service >/dev/null 2>&1 &&
    systemctl --user is-active vnc-auth-proxy.service >/dev/null 2>&1
}

provision "$@"
