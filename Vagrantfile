# Copyright 2011-2013, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
# 
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed 
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the 
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

Dir[File.expand_path('../vendor/cache/gems/**/lib',__FILE__)].each { |lib| $: << lib }
require 'highline/import'
require 'unix_crypt'
require 'yaml'
require './fact_gatherer'

include FactGatherer

NETWORK_IP = "192.168.56"
PORTS = {
  :avalon     => { :host =>  10080, :guest =>    80, :schema => "http", :host_ip => "#{NETWORK_IP}.100" }, # HTTP (Apache => Passenger => Avalon)
  :tomcat     => { :host =>  18983, :guest =>  8983, :schema => "http", :host_ip => "#{NETWORK_IP}.101" }, # HTTP (Tomcat => Solr/Fedora)
  :matterhorn => { :host =>  18080, :guest => 18080, :schema => "http", :host_ip => "#{NETWORK_IP}.102" }, # HTTP (Felix => Matterhorn)
  :red5       => { :host =>  11935, :guest =>  1935, :schema => "rtmp", :host_ip => "#{NETWORK_IP}.103" }  # RTMP (Red5)
}

gather_facts

def common_config(config, purpose, host_ip)
  config.vm.box = "nulib"
  config.vm.box_url = "http://yumrepo-public.library.northwestern.edu/nulib.box"
  config.vm.hostname = "avalon-#{purpose}"
  config.vm.network :private_network, :ip => host_ip
  config.vm.synced_folder "files", "/etc/puppet/avalon_files"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.provision :shell, :inline => "authconfig --passalgo=sha512 --update" # use SHA512 hashes in /etc/shadow

  config.vm.provision :puppet do |puppet|
    puppet.facter.merge! @facts
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "#{purpose}.pp"
    puppet.options = "--fileserverconfig=/vagrant/fileserver.conf --modulepath=/vagrant/modules --graph --graphdir=/vagrant/graphs/#{purpose}"
  end
end

Vagrant.configure("2") do |global_config|
  PORTS.each_pair do |name, mapping|
    @facts["#{name}_public_url"]     = "#{mapping[:schema]}://#{mapping[:host_ip]}:#{mapping[:guest]}"
    @facts["#{name}_public_address"] = mapping[:host_ip]
  end

  global_config.vm.define :db do |config|
    common_config(config, "db", PORTS[:tomcat][:host_ip])
  end

  global_config.vm.define :web do |config|
    common_config(config, "web", PORTS[:avalon][:host_ip])
  end

  global_config.vm.define :mhorn do |config|
    common_config(config, "mhorn", PORTS[:matterhorn][:host_ip])
  end

  global_config.vm.define :stream do |config|
    common_config(config, "stream", PORTS[:red5][:host_ip])
  end
end
