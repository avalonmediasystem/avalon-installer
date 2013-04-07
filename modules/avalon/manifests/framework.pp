# Install and configure the Avalon application
class avalon::framework {
  include epel
  include matterhorn
  include rvm

  file { ['/var/avalon/','/var/avalon/dropbox','/var/avalon/masterfiles','/var/avalon/hls_streams']:
  	ensure => directory,
  	owner  => 'avalon',
  	group  => 'avalon',
  	mode   => '0775'
	}
}
