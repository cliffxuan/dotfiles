#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

packages=(
  fcitx5
  fcitx5-chinese-addons
  fcitx5-frontend-gtk3
  fcitx5-frontend-gtk4
  fcitx5-frontend-qt5
  fcitx5-rime
  fonts-noto-cjk
)

run() {
  if ! has_gui; then
    return 0
  fi

  sudo apt-get -y install "${packages[@]}"

  mkdir -p "$HOME/.config/fcitx5"
  if [ -d "$CONFIG_DIR/fcitx5" ]; then
    for f in "$CONFIG_DIR/fcitx5"/*; do
      [ -f "$f" ] && ln -sf "$f" "$HOME/.config/fcitx5/$(basename "$f")"
    done
  fi

  if command -v fcitx5-remote >/dev/null 2>&1 && pgrep -x fcitx5 >/dev/null 2>&1; then
    fcitx5-remote -r >/dev/null 2>&1 || true
  fi
}

check() {
  if ! has_gui; then
    return 0
  fi

  dpkg-query -W -f='${Status}' "${packages[@]}" 2>/dev/null | grep -qv "ok installed" && return 1

  [ -f "$HOME/.config/fcitx5/profile" ]
}

provision "$@"
