# -*- mode: ruby -*-
# vi: set ft=ruby :

PWD = File.dirname(__FILE__)

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "uno"
  # vagrant plugin install vagrant-disksize
  config.disksize.size = "40GB"

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end

  config.vm.synced_folder PWD, "/vagrant", type: "nfs"
  config.vm.synced_folder "#{ENV['HOME']}/dev/dotfiles", "/home/vagrant/dev/dotfiles", type: "nfs"

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    mkdir $HOME/dev
    cd $HOME/dev
    echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
    if [ -d dotfiles ]
    then
      echo "dotfiles already exists"
    else
      git clone git@github.com:cliffxuan/dotfiles
    fi
    $HOME/dev/dotfiles/install.sh
    $HOME/dev/dotfiles/docker/install.sh vagrant
  SHELL
end
