#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

packages=(
  fcitx5
  fcitx5-chinese-addons
  fcitx5-configtool
  fcitx5-gtk
  fcitx5-qt
  fcitx5-rime
  librime
  noto-fonts-cjk
)

run() {
  sudo env OMARCHY_ALLOW_DIRECT_PACMAN=1 pacman -S --noconfirm --needed "${packages[@]}"

  if command -v yay >/dev/null 2>&1; then
    yay -S --needed --noconfirm rime-ice-git
  fi

  # Ensure user fcitx5 config directory exists and link dotfiles config
  mkdir -p "$HOME/.config/fcitx5"
  if [ -d "$CONFIG_DIR/fcitx5" ]; then
    for f in "$CONFIG_DIR/fcitx5"/*; do
      [ -f "$f" ] && ln -sf "$f" "$HOME/.config/fcitx5/$(basename "$f")"
    done
  fi

  # Reload fcitx5 configuration if running
  if command -v fcitx5-remote >/dev/null 2>&1 && pgrep -x fcitx5 >/dev/null 2>&1; then
    fcitx5-remote -r >/dev/null 2>&1 || true
  fi
}

check() {
  pacman -Q "${packages[@]}" >/dev/null 2>&1 &&
    [ -f "$HOME/.config/fcitx5/profile" ] &&
    grep -q "pinyin" "$HOME/.config/fcitx5/profile"
}

provision "$@"
