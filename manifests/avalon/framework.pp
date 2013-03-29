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

  file { ['/var/avalon/','/var/avalon/dropbox','/var/avalon/masterfiles','/var/avalon/hls_streams']:
  	ensure => directory,
  	owner  => 'avalon',
  	group  => 'avalon',
  	mode   => '0775'
	}
}
