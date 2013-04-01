# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'ipaddr'

Vagrant::Config.run do |config|
#  private_ip = { :addr => nil, :mask => nil }
#  begin
#    ifinfo = `VBoxManage list hostonlyifs`
#    interfaces = ifinfo.split(/\n\n/).collect { |intf| Hash[intf.split(/\n/).collect { |l| l.split(/:\s+/) }] }
#    private_ip[:addr] = ENV['VAGRANT_HOSTADDR'] || IPAddr.new(interfaces[0]['IPAddress']).succ.to_s
#    private_ip[:mask] = ENV['VAGRANT_HOSTMASK'] || interfaces[0]['NetworkMask']
#  rescue
#  end
#  if private_ip[:addr].nil?
#    $stderr.puts "No usable host only network interface found. Disabling."
#  else
#    config.vm.network :hostonly, private_ip[:addr], :netmask => private_ip[:mask]
#  end

  config.vm.box = "nulib"
  config.vm.box_url = "http://yumrepo-public.library.northwestern.edu/nulib.box"
  config.vm.share_folder "files", "/etc/puppet/files", "files"
  config.vm.share_folder("templates", "/tmp/vagrant-puppet/templates", "templates")
  config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  config.vm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

  [80, 1935, 8080, 8983].each do |port|
    config.vm.forward_port port, 10000+port
  end

  config.vbguest.auto_update = false

#  unless private_ip[:addr].nil?
#    config.vm.provision :shell do |shell|
#      shell.inline = "ifdown eth1 ; ifup eth1"
#    end
#  end

  config.vm.provision :puppet do |puppet|
    puppet.facter.merge!({ 
      'matterhorn_public_url' => 'http://localhost:18080',
      'avalon_public_url'     => 'http://localhost:10080',
      'tomcat_public_url'     => 'http://localhost:18983',
      'red5_public_url'       => 'rtmp://localhost:11935',
    })
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "avalon.pp"
    puppet.options = "--fileserverconfig=/vagrant/fileserver.conf --modulepath=/vagrant/modules --hiera_config=/vagrant/heira/heira.yml --templatedir=/tmp/vagrant-puppet/templates"
  end
end

