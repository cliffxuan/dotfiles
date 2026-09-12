#!/usr/bin/env bash
packages=(
  fcitx5
  fcitx5-chinese-addons
  fcitx5-frontend-gtk3
  fcitx5-frontend-gtk4
  fcitx5-frontend-qt5
  fcitx5-rime
  fonts-noto-cjk
)
sudo apt-get -y install "${packages[@]}"
