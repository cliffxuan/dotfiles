#!/usr/bin/env bash
# install the yum-utils package (which provides the yum-config-manager utility)
function provision {
  sudo yum install -y yum-utils
}


function check {
  provision | grep -qE "Package yum-utils-.* already installed and latest version"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  provision
fi
