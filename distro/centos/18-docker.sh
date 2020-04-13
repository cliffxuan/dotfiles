#!/usr/bin/env bash
function provision {
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo yum install -y docker-ce docker-ce-cli containerd.io
}


function check {
  docker version 2>&1 | grep -qE "Version: +19."
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  provision
fi
