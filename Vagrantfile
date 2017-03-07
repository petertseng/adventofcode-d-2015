# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box = 'ogarcia/archlinux-x64'
  config.vm.provision 'shell', inline: <<-SHELL
    ln -s /vagrant /home/vagrant/d
    pacman -Sy --noconfirm rxvt-unicode-terminfo dlang-dmd dub
  SHELL
end
