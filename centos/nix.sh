#!/usr/bin/env bash
if [ "$(whoami)" == "root" ]
then
  printf "cannot run as root\n"
  exit 1
fi
curl -L https://nixos.org/nix/install | sh
