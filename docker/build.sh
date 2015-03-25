#!/usr/bin/env bash
if [[ -z $1 ]]
then
    KEY='foo'
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
docker build -t base --no-cache .
