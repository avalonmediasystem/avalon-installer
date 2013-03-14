class avalon::framework {
  include epel
  include nulrepo
  include mediainfo
  include rvm

  package { ["curl", "sqlite", "v8-devel", "zip"]:
    ensure => present
  }
  #todo parameterize everything that follows.
  file { "/home/vagrant/.bash_profile":
    source => "puppet:///local/bash_profile",
    ensure => present
  }

  rvm::system_user { vagrant: ; }

  rvm_system_ruby {
  'ruby-1.9.3-p392':
    ensure => 'present',
    default_use => true
  }

  rvm_gemset {
    'ruby-1.9.3-p392@avalon':
    ensure => present,
    require => Rvm_system_ruby['ruby-1.9.3-p392']
  }


  rvm_gem {
  'ruby-1.9.3-p392@avalon/bundler':
    ensure => '~> 1.2.3',
    require => Rvm_gemset['ruby-1.9.3-p392@avalon']
  }

}
