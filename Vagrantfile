# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "nulib"
  config.vm.box_url = "http://yumrepo.library.northwestern.edu/nulib.box"
  config.vm.share_folder "files", "/etc/puppet/files", "files"
	config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  config.vm.forward_port 8080, 38080

  config.vbguest.auto_update = false

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "avalon.pp"
    puppet.options = "--fileserverconfig=/vagrant/fileserver.conf --modulepath=/vagrant/modules --hiera_config=/vagrant/heira/heira.yml"
  end
end

