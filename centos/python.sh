#!/usr/bin/env bash
version=3.7.7
# yum install -y gcc openssl-devel bzip2-devel libffi-devel python3-devel sqlite-devel readline-devel
yum install -y gcc openssl-devel bzip2-devel libffi-devel sqlite-devel readline-devel
cd /tmp
rm Python-$version.tgz
curl -OL https://www.python.org/ftp/python/$version/Python-$version.tgz
rm -rf Python-$version
tar xzf Python-$version.tgz
cd Python-$version
./configure --enable-optimizations --enable-shared
make altinstall
ln -sf /usr/local/bin/python${version::3} /usr/local/bin/python${version::1}
ln -sf /usr/local/bin/python${version::3}m-config /usr/local/bin/python${version::1}m-config
# for LD_LIBRARY_PATH
echo /usr/local/lib > /etc/ld.so.conf.d/python-$version.conf
ldconfig
