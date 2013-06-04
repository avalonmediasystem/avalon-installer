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
require 'ipaddr'
require 'yaml'
require './fact_gatherer'

include FactGatherer

NETWORK_IP = "192.168.56"
@hosts = {
  :avalon     => { :name => 'web',    :port =>    80, :schema => "http" }, # HTTP (Apache => Passenger => Avalon)
  :db         => { :name => 'db',     :port =>  8983, :schema => "http" }, # HTTP (Tomcat => Solr/Fedora)
  :matterhorn => { :name => 'mhorn',  :port =>  8080, :schema => "http" }, # HTTP (Felix => Matterhorn)
  :rtmp       => { :name => 'stream', :port =>  1935, :schema => "rtmp" }  # RTMP (Red5)
}
host_ip = IPAddr.new("#{NETWORK_IP}.100")
[:avalon,:db,:matterhorn,:rtmp].each do |role|
  @hosts[role][:host_ip] = host_ip.to_s
  host_ip = host_ip.succ if ENV['VAGRANT_MULTI']
end

@fact_file = File.expand_path('../hiera/data/vagrant.yaml',__FILE__)
gather_facts(@fact_file)

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

  config.vm.provision(:puppet, :module_path => "modules") do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "init.pp"
    puppet.options = "--fileserverconfig=/vagrant/fileserver.conf --hiera_config=/vagrant/hiera/hiera.yaml"
  end
end

Vagrant.configure("2") do |global_config|
  @hosts.each_pair do |name, mapping|
    @facts["#{name}_url"]     = "#{mapping[:schema]}://#{mapping[:host_ip]}:#{mapping[:port]}"
    @facts["#{name}_address"] = mapping[:host_ip]
  end
  @facts["stream_address"] = @hosts[:rtmp][:host_ip]

  File.open(@fact_file,'w') { |f| f.write(YAML.dump(@facts)) }

  if ENV['VAGRANT_MULTI']
    [:db,:avalon,:matterhorn,:rtmp].each do |role|
      box = @hosts[role][:name]
      global_config.vm.define box do |config|
        common_config(config, box, @hosts[role][:host_ip])
      end
    end
  else
    common_config(global_config, "box", "#{NETWORK_IP}.100")
  end
end
