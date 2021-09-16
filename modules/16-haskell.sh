#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"
# shellcheck source=/dev/null
source "$HOME/.nix-profile/etc/profile.d/nix.sh"

softlink_package_dir() {
  # https://github.com/haskell/cabal/issues/6262
  # https://gitlab.haskell.org/ghc/ghc/-/issues/17341
  cabal v1-install haskell-say
  PACKAGE_CONF_D=$(ghc-pkg list | grep "$HOME")
  PACKAGE_DB=$(find ~/.cabal -name package.db -type d)
  rm -rf "$PACKAGE_CONF_D"
  ln -s "$PACKAGE_DB" "$PACKAGE_CONF_D"
}

run() {
  nix-env -i -f '<nixpkgs>' -E 'pkgs: (pkgs {}).ghc.withPackages (hp: with hp; [ zlib ])'
  nix-env -iA nixpkgs.haskellPackages.cabal-install
  cabal update
  softlink_package_dir
}

check() {
  hash ghc 2>/dev/null || return 1
  hash cabal 2>/dev/null || return 1
}


provision "$@"
