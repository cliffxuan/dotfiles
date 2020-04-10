#!/usr/bin/env bash
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-disksize
# latest version does not work on centos7
# https://github.com/Learnosity/vagrant-nfs_guest/issues/57
vagrant plugin install vagrant-nfs_guest --plugin-version=1.0.0
