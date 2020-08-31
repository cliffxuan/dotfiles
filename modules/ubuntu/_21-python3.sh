#!/usr/bin/env bash
# build and install python3
version=3.8.2
cd /tmp; curl -O https://www.python.org/ftp/python/$version/Python-$version.tgz; tar -xf Python-$version.tgz
cd /tmp/Python-$version; ./configure --enable-optimizations --enable-shared; make; sudo make install
# for LD_LIBRARY_PATH
echo /usr/local/lib | sudo tee -a /etc/ld.so.conf.d/python-$version.conf
sudo ldconfig
