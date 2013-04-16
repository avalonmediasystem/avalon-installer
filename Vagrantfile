Dir[File.expand_path('../vendor/cache/gems/**/lib',__FILE__)].each { |lib| $: << lib }
require 'highline/import'
require 'unix_crypt'
require 'yaml'
require './fact_gatherer'

include FactGatherer

PORTS = {
  :avalon     => { :host =>  10080, :guest =>    80, :schema => "http" }, # HTTP (Apache => Passenger => Avalon)
  :red5       => { :host =>  11935, :guest =>  1935, :schema => "rtmp" }, # RTMP (Red5)
  :tomcat     => { :host =>  18983, :guest =>  8983, :schema => "http" }, # HTTP (Tomcat => Solr/Fedora)
  :matterhorn => { :host =>  18080, :guest => 18080, :schema => "http" }  # HTTP (Felix => Matterhorn)
}

gather_facts
Vagrant.configure("2") do |config|
  config.vm.box = "nulib"
  config.vm.box_url = "http://yumrepo-public.library.northwestern.edu/nulib.box"
  config.vm.hostname = "avalon-box"
  config.vm.synced_folder "files", "/etc/puppet/avalon_files"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  PORTS.each_pair do |name, mapping|
    config.vm.network :forwarded_port, mapping
    @facts["#{name}_public_url"] = "#{mapping[:schema]}://localhost:#{mapping[:host]}"
  end

  config.vm.provision :shell, :inline => "authconfig --passalgo=sha512 --update" # use SHA512 hashes in /etc/shadow

  config.vm.provision :puppet do |puppet|
    puppet.facter.merge! @facts
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "init.pp"
    puppet.options = "--fileserverconfig=/vagrant/fileserver.conf --modulepath=/vagrant/modules --hiera_config=/vagrant/hiera/hiera.yml"
  end

end
