#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  mkdir -p "$HOME/.config/mise"
  [ -f "$HOME/.config/mise/config.toml" ] || ln -sf "$CONFIG_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"

  if command -v mise >/dev/null 2>&1; then
    mise install "aqua:tailscale/tailscale"
    mise reshim
  elif [ -x "$HOME/.local/bin/mise" ]; then
    "$HOME/.local/bin/mise" install "aqua:tailscale/tailscale"
    "$HOME/.local/bin/mise" reshim
  fi

  if ! command -v tailscale >/dev/null 2>&1; then
    echo "tailscale binary not available via mise" >&2
    return 1
  fi

  mkdir -p "$HOME/.zfunc"
  tailscale completion zsh >"$HOME/.zfunc/_tailscale"
}

check() {
  command -v tailscale >/dev/null 2>&1 &&
    [ -s "$HOME/.zfunc/_tailscale" ]
}

provision "$@"
