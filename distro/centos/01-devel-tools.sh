#!/usr/bin/env bash
function provision {
  sudo yum groupinstall -y "Development Tools"
}


function check {
  provision 2>&1 | grep -q "No packages in any requested group available to install or update"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  provision
fi
