require 'ipaddr'


port_mappings = {
  :avalon     => { :local =>  10080, :remote =>    80, :schema => "http" }, # HTTP (Apache => Passenger => Avalon)
  :red5       => { :local =>  11935, :remote =>  1935, :schema => "rtmp" }, # RTMP (Red5)
  :tomcat     => { :local =>  18983, :remote =>  8983, :schema => "http" }, # HTTP (Tomcat => Solr/Fedora)
  :matterhorn => { :local =>  18080, :remote => 18080, :schema => "http" }  # HTTP (Felix => Matterhorn)
}

Vagrant::Config.run do |config|
  config.vm.box = "nulib"
  config.vm.box_url = "http://yumrepo-public.library.northwestern.edu/nulib.box"
  config.vm.host_name = "avalon-box"
  config.vm.share_folder "files", "/etc/puppet/files", "files"
  config.vm.share_folder("templates", "/tmp/vagrant-puppet/templates", "templates")
  config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  config.vm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

  mapping_facts = {}
  port_mappings.each_pair do |name, mapping|
    config.vm.forward_port mapping[:remote], mapping[:local]
    mapping_facts["#{name}_public_url"] = "#{mapping[:schema]}://localhost:#{mapping[:local]}"
  end

  config.vbguest.auto_update = false

  config.vm.provision :puppet do |puppet|
    puppet.facter.merge! mapping_facts
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "avalon.pp"
    puppet.options = "--fileserverconfig=/vagrant/fileserver.conf --modulepath=/vagrant/modules --hiera_config=/vagrant/heira/heira.yml --templatedir=/tmp/vagrant-puppet/templates"
  end

end

puts "Avalon is now installed at http://localhost:#{port_mappings[:avalon][:local]}"
