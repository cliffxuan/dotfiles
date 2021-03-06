#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

version=3.8.2
path=/usr/local/bin/python${version::3}

run() {
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
  sudo ln -sf $path /usr/local/bin/python${version::1}
  sudo ln -sf ${path}m-config /usr/local/bin/python${version::1}m-config
  # for LD_LIBRARY_PATH
  echo /usr/local/lib | sudo tee -a /etc/ld.so.conf.d/python-$version.conf
  sudo ldconfig
}


check() {
  python3 -c "import sys; print(sys.version)" 2>&1 | grep -q $version
}


provision "$@"
