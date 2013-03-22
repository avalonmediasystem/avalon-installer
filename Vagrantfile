# -*- mode: ruby -*-
# vi: set ft=ruby :

private_addr = ENV['VAGRANT_HOSTADDR'] || "192.168.56.100"
private_mask = ENV['VAGRANT_HOSTMASK'] || "255.255.255.0"
Vagrant::Config.run do |config|
  config.vm.box = "nulib"
  config.vm.box_url = "http://yumrepo-public.library.northwestern.edu/nulib.box"
  config.vm.share_folder "files", "/etc/puppet/files", "files"
  config.vm.network :hostonly, private_addr, :netmask => private_mask
	config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  config.vm.forward_port 8080, 38080
  config.vm.forward_port 9090, 39090

  config.vbguest.auto_update = false

  config.vm.provision :shell do |shell|
    shell.inline = "ifdown eth1 ; ifup eth1"
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "avalon.pp"
    puppet.options = "--fileserverconfig=/vagrant/fileserver.conf --modulepath=/vagrant/modules --hiera_config=/vagrant/heira/heira.yml"
  end
end

