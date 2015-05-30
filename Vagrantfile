Vagrant.configure(2) do |config|
  config.vm.box = "chef/centos-6.6"

  chef_dk_url = "https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.5.1-1.el6.x86_64.rpm"

  config.vm.define :bootstrap do | b |
    b.vm.hostname = "bootstrap"
    b.vm.network :private_network, ip:"192.168.228.30"
    b.vm.provider "virtualbox" do |v|
      v.name = "bootstrap"
      v.cpus = 2
      v.memory = 2048
      v.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    end
    b.vm.provision :shell, :inline => "echo provision start"
    b.vm.provision :shell, :inline => "yum install -y git, rsync"
    b.vm.provision :shell, :inline => "yum install -y #{chef_dk_url}"
    b.vm.provision :shell, :inline => "su - vagrant -c 'chef gem install knife-solo'"
    b.vm.provision :shell, :inline => "echo provision end"
  end
end
