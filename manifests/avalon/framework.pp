class avalon::framework {
  include epel
  include nulrepo
  include mediainfo

  package { ["curl", "gcc-c++", "libcurl-devel", "sqlite", "v8-devel", 
    "libxml2-devel", "libxslt-devel", "make", "zip"]:
    ensure => present
  }

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
}
