#!/usr/bin/env bash
version=3.7.7
sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel sqlite-devel readline-devel
cd /tmp || exit
rm -f Python-$version.tgz
curl -OL https://www.python.org/ftp/python/$version/Python-$version.tgz
sudo rm -rf Python-$version
tar xzf Python-$version.tgz
cd Python-$version || exit
./configure --enable-shared
make
sudo make install
sudo ln -sf /usr/local/bin/python${version::3} /usr/local/bin/python${version::1}
sudo ln -sf /usr/local/bin/python${version::3}m-config /usr/local/bin/python${version::1}m-config
# for LD_LIBRARY_PATH
echo /usr/local/lib | sudo tee -a /etc/ld.so.conf.d/python-$version.conf
sudo ldconfig
