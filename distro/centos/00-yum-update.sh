#!/usr/bin/env bash
function provision {
  sudo yum update -y
}


function check {
  sudo yum update -y | grep -q "No packages marked for update"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  provision
fi
