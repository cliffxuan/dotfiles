#!/usr/bin/env bash
function provision {
  sudo yum install -y xsel
}


function check {
  provision | grep -qE "Package xsel-.* already installed and latest version"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  provision
fi
