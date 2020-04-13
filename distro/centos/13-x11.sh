#!/usr/bin/env bash
function provision {
  sudo yum install -y xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps
}


function check {
  provision | grep -q "Nothing to do"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  provision
fi
