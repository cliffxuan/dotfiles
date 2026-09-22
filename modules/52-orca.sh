#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  mkdir -p "$HOME/.config/mise"
  [ -f "$HOME/.config/mise/config.toml" ] || ln -sf "$CONFIG_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"

  if command -v mise >/dev/null 2>&1; then
    mise install github:stablyai/orca
    mise reshim
  elif [ -x "$HOME/.local/bin/mise" ]; then
    "$HOME/.local/bin/mise" install github:stablyai/orca
    "$HOME/.local/bin/mise" reshim
  fi

  if ! command -v orca.AppImage >/dev/null 2>&1 && [ ! -x "$HOME/.local/share/mise/installs/github-stablyai-orca/latest/orca.AppImage" ]; then
    echo "orca.AppImage binary not available via mise" >&2
    return 1
  fi

  mkdir -p "$HOME/.local/bin"
  ln -sf "$SCRIPT_DIR/orca" "$HOME/.local/bin/orca"
  ln -sf "$SCRIPT_DIR/orca" "$HOME/.local/bin/orca-ide"
  ln -sf "$SCRIPT_DIR/orca-server" "$HOME/.local/bin/orca-server"
  ln -sf "$SCRIPT_DIR/orca-pair" "$HOME/.local/bin/orca-pair"

  mkdir -p "$HOME/.zfunc"
  ln -sf "$BASE_DIR/completions/_orca" "$HOME/.zfunc/_orca"
  ln -sf "$BASE_DIR/completions/_orca" "$HOME/.zfunc/_orca-ide"

  if command -v systemctl >/dev/null 2>&1; then
    mkdir -p "$HOME/.config/systemd/user"
    ln -sf "$CONFIG_DIR/systemd/user/orca-server.service" "$HOME/.config/systemd/user/orca-server.service"
    loginctl enable-linger "$USER" 2>/dev/null || true
    systemctl --user daemon-reload
    systemctl --user enable --now orca-server.service
  fi
}

check() {
  (command -v orca >/dev/null 2>&1 || command -v orca-ide >/dev/null 2>&1 || command -v orca.AppImage >/dev/null 2>&1) &&
    [ -s "$HOME/.zfunc/_orca" ] &&
    [ -s "$HOME/.zfunc/_orca-ide" ] &&
    [ -L "$HOME/.local/bin/orca" ] &&
    [ -L "$HOME/.local/bin/orca-ide" ] &&
    [ -L "$HOME/.local/bin/orca-server" ] &&
    [ -L "$HOME/.local/bin/orca-pair" ] &&
    (! command -v systemctl >/dev/null 2>&1 || (
      [ -L "$HOME/.config/systemd/user/orca-server.service" ] &&
        systemctl --user is-enabled orca-server.service >/dev/null 2>&1 &&
        systemctl --user is-active orca-server.service >/dev/null 2>&1
    ))
}

provision "$@"
