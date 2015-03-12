#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

cp ~/.ssh/id_rsa .
docker build -t base --no-cache .
