#!/usr/bin/env bash
function provision {
  curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
  sudo yum install -y nodejs
}


function check {
  node -v 2>&1 | grep -q "v12."
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  provision
fi
