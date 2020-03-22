#!/usr/bin/env bash
version=3.7.7
yum install -y gcc openssl-devel bzip2-devel libffi-devel python3-devel sqlite-devel readline-devel
cd /tmp
rm Python-$version.tgz
curl -OL https://www.python.org/ftp/python/$version/Python-$version.tgz
rm -rf Python-$version
tar xzf Python-$version.tgz
cd Python-$version
./configure --enable-optimizations --enable-shared
make altinstall
# for LD_LIBRARY_PATH
echo /usr/local/lib > /etc/ld.so.conf.d/python-$version.conf
ldconfig
