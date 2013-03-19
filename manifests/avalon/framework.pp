# Install and configure the Avalon application
class avalon::framework {
  include epel
  include matterhorn
  include rvm

  #todo parameterize everything that follows.
  file { '/home/vagrant/.bash_profile':
    ensure => present,
    source => 'puppet:///local/bash_profile',
  }


}
