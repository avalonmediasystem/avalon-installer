# Install and configure the Avalon application
class avalon::framework {
  include epel
  include nulrepo
  include mediainfo
  include matterhorn
  include rvm

  package { ['curl', 'sqlite', 'v8-devel', 'zip']:
    ensure => present
  }
  #todo parameterize everything that follows.
  file { '/home/vagrant/.bash_profile':
    ensure => present,
    source => 'puppet:///local/bash_profile',
  }

  rvm::system_user { vagrant: ; }

  rvm_system_ruby {
  'ruby-1.9.3-p392':
    ensure      => 'present',
    default_use => true,
  }

  rvm_gemset {
    'ruby-1.9.3-p392@avalon':
    ensure  => present,
    require => Rvm_system_ruby['ruby-1.9.3-p392'],
  }
  ##TODO Parameterize at worst, be more clever
  ##TODO move into "avalon" class (Ruby/Apache/Passenger)
  rvm_gem {
  'ruby-1.9.3-p392@avalon/bundler':
    ensure  => '~> 1.2.3',
    require => Rvm_gemset['ruby-1.9.3-p392@avalon'],
  }

}