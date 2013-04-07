PORTS = {
  :avalon     => { :host =>  10080, :guest =>    80, :schema => "http" }, # HTTP (Apache => Passenger => Avalon)
  :red5       => { :host =>  11935, :guest =>  1935, :schema => "rtmp" }, # RTMP (Red5)
  :tomcat     => { :host =>  18983, :guest =>  8983, :schema => "http" }, # HTTP (Tomcat => Solr/Fedora)
  :matterhorn => { :host =>  18080, :guest => 18080, :schema => "http" }  # HTTP (Felix => Matterhorn)
}

Vagrant.configure("2") do |config|
  config.vm.box = "nulib"
  config.vm.box_url = "http://yumrepo-public.library.northwestern.edu/nulib.box"
  config.vm.hostname = "avalon-box"
  config.vm.synced_folder "files", "/etc/puppet/avalon_files"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  mapping_facts = {}
  PORTS.each_pair do |name, mapping|
    config.vm.network :forwarded_port, mapping
    mapping_facts["#{name}_public_url"] = "#{mapping[:schema]}://localhost:#{mapping[:host]}"
  end

  config.vm.provision :puppet do |puppet|
    puppet.facter.merge! mapping_facts
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "init.pp"
    puppet.options = "--fileserverconfig=/vagrant/fileserver.conf --modulepath=/vagrant/modules --hiera_config=/vagrant/heira/heira.yml --templatedir=/tmp/vagrant-puppet/templates"
  end
end
