# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "uno"

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    mkdir $HOME/dev
    cd $HOME/dev
    echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
    git clone git@github.com:cliffxuan/dotfiles
    $HOME/dev/dotfiles/install.sh
    $HOME/dev/dotfiles/docker/install.sh
  SHELL
end
