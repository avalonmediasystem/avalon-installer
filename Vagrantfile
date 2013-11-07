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

PORTS = {
  :avalon     => { :host =>  10080, :guest =>    80, :schema => "http" }, # HTTP (Apache => Passenger => Avalon)
  :red5       => { :host =>  11935, :guest =>  1935, :schema => "rtmp" }, # RTMP (Red5)
  :tomcat     => { :host =>  18983, :guest =>  8983, :schema => "http" }, # HTTP (Tomcat => Solr/Fedora)
  :matterhorn => { :host =>  18080, :guest => 18080, :schema => "http" }  # HTTP (Felix => Matterhorn)
}

gather_facts
Vagrant.configure("2") do |config|
  config.vm.box = "centos-minimal-desktop"
  config.vm.box_url = "http://yumrepo-public.library.northwestern.edu/centos_x86_64_minimal_desktop.box"
  config.vm.hostname = "avalon-box"
  config.vm.synced_folder "files", "/etc/puppet/avalon_files"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "3072"]
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--usb", "off"]
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
    puppet.options = "--fileserverconfig=/vagrant/fileserver.conf --modulepath=/vagrant/modules"
  end

end
