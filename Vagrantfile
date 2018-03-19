# -*- mode: ruby -*-
# vi: set ft=ruby :

# To solve issue https://github.com/freedomofpress/securedrop/pull/2973
if Vagrant::VERSION < '2.0.3'
  Vagrant::DEFAULT_SERVER_URL.replace('https://vagrantcloud.com')
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  #config.vm.box = "debian/stretch64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  # List of boxes
  boxes_list = {
    #'hostname' => [ 'box_to_use', 'ip' , ram_size_mb, disksize ],
    'wgsdebian7'  => ['debian/wheezy64', '192.168.5.11', 256, [ { 'guest_port': 443, 'host_port': 8443 } ] ],
    'wgsdebian8'  => ['debian/jessie64', '192.168.5.12', 256, [ { 'guest_port': 443, 'host_port': 8444 } ] ],
    'wgsdebian9'  => ['debian/stretch64', '192.168.5.13', 256, [ { 'guest_port': 443, 'host_port': 8445 } ] ],
    'wgscentos6'  => ['centos/6', '192.168.5.14', 256, [ { 'guest_port': 443, 'host_port': 8446 } ] ],
    'wgscentos7'  => ['centos/7', '192.168.5.15', 256, [ { 'guest_port': 443, 'host_port': 8447 } ] ],
    'wgsubuntu14' => ['ubuntu/trusty64', '192.168.5.16', 384, [ { 'guest_port': 443, 'host_port': 8448 } ] ],
  }
  # Provision
  boxes_list.each do | boxhost, boxprops|
    config.vm.define "#{boxhost}" do |host|
      host.vm.box = boxprops.at(0)
      host.vm.provider "virtualbox" do |vbox|
        vbox.customize ["modifyvm", :id, "--nictype1", "82540EM"]
        vbox.customize ["modifyvm", :id, "--nictype2", "82540EM"]
        vbox.memory = boxprops.at(2)
        # Number of CPUs for this host
        host = RbConfig::CONFIG['host_os']
        if host =~ /darwin/
          cpus = `sysctl -n hw.ncpu`.to_i
        elsif host =~ /linux/
          cpus = `nproc`.to_i
        else # Windows or anything else ...
          cpus = 2
        end
        vbox.cpus = cpus

      end
      host.vm.hostname = "#{boxhost}.#{$domain_name}"
      host.vm.network :private_network, ip: "#{boxprops.at(1)}"

      if boxprops.length > 3
        # Port mapping for this host
        for port_map in boxprops.at(3)
          host.vm.network :forwarded_port, guest: port_map[:guest_port], guest_ip: "#{boxprops.at(1)}", host: port_map[:host_port], protocol: "tcp"
        end
      end
    end
  end

  # Here, we'll ansibleize the machine.
  config.vm.provision :ansible do |ansible|
    ansible.playbook = "playbooks/WGserver.yml"
    ansible.config_file = "ansible.cfg"
  end
end
