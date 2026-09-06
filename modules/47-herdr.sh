#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  # Remove legacy direct-installed binary if present to avoid shadowing mise
  rm -f "$HOME/.local/bin/herdr"

  mkdir -p "$HOME/.config/mise"
  [ -f "$HOME/.config/mise/config.toml" ] || ln -sf "$CONFIG_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"

  if command -v mise >/dev/null 2>&1; then
    mise install herdr
    mise reshim
  elif [ -x "$HOME/.local/bin/mise" ]; then
    "$HOME/.local/bin/mise" install herdr
    "$HOME/.local/bin/mise" reshim
  fi

  if ! command -v herdr >/dev/null 2>&1; then
    echo "herdr binary not available via mise" >&2
    return 1
  fi

  mkdir -p "$HOME/.zfunc"
  herdr completion zsh >"$HOME/.zfunc/_herdr"

  mkdir -p "$HOME/.zinit/completions"
  ln -sf "$HOME/.zfunc/_herdr" "$HOME/.zinit/completions/_herdr"

  if command -v agy >/dev/null 2>&1 || [ -d "$HOME/.gemini" ]; then
    herdr integration install antigravity-cli
  fi
}

check() {
  [ ! -f "$HOME/.local/bin/herdr" ] &&
    command -v herdr >/dev/null 2>&1 &&
    [ -s "$HOME/.zfunc/_herdr" ] &&
    [ -e "$HOME/.zinit/completions/_herdr" ] &&
    (! { command -v agy >/dev/null 2>&1 || [ -d "$HOME/.gemini" ]; } ||
      herdr integration status 2>/dev/null | grep -Eq '^antigravity-cli:[[:space:]]+current')
}

provision "$@"
