#!/usr/bin/env bash
function provision {
  sudo yum install -y http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
  sudo yum install -y git
}


function check {
  git version 2>&1 | grep -qE "^git version 2\.2[0-9]\.[0-9]$"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  provision
fi
