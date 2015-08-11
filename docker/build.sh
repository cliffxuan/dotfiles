#!/usr/bin/env bash
if [[ -z $1 ]]
then
    KEY=~/.ssh/id_rsa
else
    if [[ -a $1 ]]
    then
        KEY=$1
    else
        echo "Private key \"$1\" does not exist"
        exit
    fi
fi
echo $KEY
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

cp $KEY id_rsa
chmod 400 id_rsa
docker build -t cliff/base --no-cache .
