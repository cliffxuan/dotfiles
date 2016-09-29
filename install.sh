#!/bin/bash
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

apt-get install -y zsh
$BASE_DIR/kickoff.sh
