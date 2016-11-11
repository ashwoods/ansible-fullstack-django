# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

_config = YAML.load(File.open(File.join(File.dirname(__FILE__), "vagrant.yml"), File::RDONLY).read)
CONF = _config


Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"

  # config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: CONF["ipaddress"]
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true

    # Customize the amount of memory on the VM:
    vb.memory = CONF["ram"]
    vb.cpus = CONF["cpus"]
  end
end
