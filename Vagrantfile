# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.box = "chef/centos-7.1"

  # General networking
  config.vm.network "private_network", type: "dhcp"
  config.hostmanager.enabled = true
  config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
    if vm.id
      `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
    end
  end

  config.vm.provision :shell, path: "init-kolla.sh"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192"
  end

  keyname = 'ansible-key'
  publickey = File.read("#{keyname}.pub")
  if not File.exist?(keyname)
    `ssh-keygen -f #{keyname} -P ''`
  end
  privatekey = File.read(keyname)
  publickey = File.read("#{keyname}.pub")
  config.vm.provision "shell", inline: <<-SHELL
    echo '#{privatekey}' > ~vagrant/.ssh/#{keyname}
    echo '#{publickey}' > ~vagrant/.ssh/#{keyname}.pub
    echo '#{publickey}' >> ~vagrant/.ssh/authorized_keys
    chmod 0600 ~vagrant/.ssh/*
    echo 'Host *' > ~vagrant/.ssh/config
    echo 'StrictHostKeyChecking no' >> ~vagrant/.ssh/config
  SHELL

  (0..2).each do |i|
    config.vm.define "kolla#{i}" do |kolla|
      kolla.vm.hostname = "kolla#{i}"
    end
  end
end
