Dir[File.expand_path('../vendor/cache/gems/**/lib',__FILE__)].each { |lib| $: << lib }
require 'highline/import'
require 'unix_crypt'
require 'yaml'

PORTS = {
  :avalon     => { :host =>  10080, :guest =>    80, :schema => "http" }, # HTTP (Apache => Passenger => Avalon)
  :red5       => { :host =>  11935, :guest =>  1935, :schema => "rtmp" }, # RTMP (Red5)
  :tomcat     => { :host =>  18983, :guest =>  8983, :schema => "http" }, # HTTP (Tomcat => Solr/Fedora)
  :matterhorn => { :host =>  18080, :guest => 18080, :schema => "http" }  # HTTP (Felix => Matterhorn)
}

fact_file = File.expand_path('../config/avalon-install.yml',__FILE__)
@facts = YAML.load(File.read(fact_file))
if @facts['first_run']
  @facts['avalon_dropbox_user'] = ask("Username for Avalon Dropbox: ") do |q|
    q.validate = /.+{3}/
    q.default = @facts['avalon_dropbox_user']
  end

  passwords = ['a','b']
  while passwords.uniq.length > 1
    passwords[0] = ask("Password for Avalon Dropbox: ") do |q|
      q.echo = 'x'
      q.validate = /.+{6}/
    end

    passwords[1] = ask("Confirm Password for Avalon Dropbox: ") do |q|
      q.echo = 'x'
    end
    if passwords.uniq.length > 1
      say("Passwords do not match")
    end
  end
  @facts['avalon_dropbox_password'] = passwords[0]

  @facts['avalon_admin_user'] = ask("Initial Avalon Collection/Group Manager E-Mail: ") do |q|
    q.validate = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
    q.default = @facts['avalon_admin_user']
  end

  @facts['rails_env'] = ask("Rails environment to run under: ") do |q|
    q.case = :down
    q.default = 'production'
    q.validate = /^production|test|development$/
  end

  @facts.delete('first_run')
  File.open(fact_file,'w') { |f| f.write(YAML.dump(@facts)) }
end

unless @facts['avalon_dropbox_password'].nil?
  salt = rand(36**8).to_s(36)
  @facts['avalon_dropbox_password_hash'] = UnixCrypt::MD5.build(@facts.delete('avalon_dropbox_password'),salt)
  File.open(fact_file,'w') { |f| f.write(YAML.dump(@facts)) }
end

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

  config.vm.provision :puppet do |puppet|
    puppet.facter.merge! @facts
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "init.pp"
    puppet.options = "--fileserverconfig=/vagrant/fileserver.conf --modulepath=/vagrant/modules --hiera_config=/vagrant/hiera/hiera.yml --templatedir=/tmp/vagrant-puppet/templates"
  end

end

