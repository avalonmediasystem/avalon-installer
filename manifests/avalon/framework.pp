class avalon::framework {
  include epel
  include nulrepo
  include mediainfo

  package { ["curl", "gcc-c++", "sqlite", "v8-devel", 
    "libxml2-devel", "libxslt-devel", "make", "zip"]:
    ensure => present
  }
  #todo parameterize everything that follows.
  file { "/home/vagrant/.bash_profile":
    source => "puppet:///local/bash_profile",
    ensure => present
  }

  rbenv::install { "vagrant":
    group => "vagrant",
    home  => "/home/vagrant"
  }

  rbenv::compile { "1.9.3-p392":
    user => "vagrant",
    home => "/home/vagrant",
    global => true,
    source => "puppet:///local/ruby-def",
    require => Rbenv::Install["vagrant"]
  }
  ##TODO Parameterize at worst, be more clever
  exec { 'passenger_gem_install':
  user    => 'vagrant',
  command => 'gem install passenger',
  unless  => 'gem list passenger | grep passenger',
  path    => ['/home/vagrant/.rbenv/shims',
              '/home/vagrant/.rbenv/bin',
              '/usr/local/bin',
              '/bin', '/usr/bin', '/usr/local/sbin',
              '/usr/sbin','/sbin','/home/vagrant/bin',],
  require => Rbenv::Compile ["1.9.3-p392"],
  }

}
