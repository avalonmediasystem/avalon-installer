class avalon::webapp {
  include epel
  include nulrepo

  package { ["curl", "gcc-c++", "libcurl-devel", "sqlite", "v8-devel", 
    "libxml2-devel", "libxslt-devel", "make", "mediainfo", "zip"]:
    ensure => present
  }

  file { "/home/vagrant/.bash_profile":
    source => "puppet:///local/bash_profile"
  }

  rbenv::install { "vagrant":
    group => "vagrant",
    home  => "/home/vagrant"
  }

  rbenv::compile { "1.9.3-p392":
    user => "vagrant",
    home => "/home/vagrant",
    global => true,
    require => Rbenv::Install["vagrant"]
  }
}
