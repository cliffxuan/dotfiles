#!/usr/bin/env bash
function provision {
  sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
}


function check {
  provision 2>&1 | grep -q "Error: Nothing to do"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  provision
fi
