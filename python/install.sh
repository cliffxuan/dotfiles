#!/usr/bin/env bash
# build and install python3
version=3.8.2
# python deps
sudo apt-get install -y python3-dev libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev zlib1g-dev
# openssl deps
sudo apt-get install -y libssl-dev libffi-dev
# lxml deps
sudo apt-get install -y libxml2-dev libxslt-dev

cd /tmp; curl -O https://www.python.org/ftp/python/$version/Python-$version.tgz; tar -xf Python-$version.tgz
cd /tmp/Python-$version; ./configure --enable-optimizations --enable-shared; make; sudo make install
# for LD_LIBRARY_PATH
echo /usr/local/lib > sudo tee -a /etc/ld.so.conf.d/python-$version.conf
sudo ldconfig

# install pip
curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
sudo python3 /tmp/get-pip.py

# install useful libraries
sudo pip3 install virtualenv virtualenvwrapper pipenv flake8 black httpie
