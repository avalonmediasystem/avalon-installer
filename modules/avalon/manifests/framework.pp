# Install and configure the Avalon application
class avalon::framework {
  include epel
  include matterhorn
  include rvm
  include stdlib

  if $avalon_dropbox_password_hash =~ /^$/  {
    fail("Missing fact: avalon_dropbox_password")
  }
  
  group { 'dropbox':
    ensure => present,
    system => true
  }

  user { $avalon_dropbox_user:
    ensure   => present,
    system   => true,
    gid      => 'dropbox',
    home     => '/dropbox', # because it's already chrooted to /var/avalon
    password => $avalon_dropbox_password_hash,
    require  => Group['dropbox']
  }

  file { '/var/avalon':
    ensure  => directory,
    mode    => 0755
  }

  file { '/var/avalon/dropbox':
    ensure  => directory,
    owner   => 'avalondrop',
    group   => 'dropbox',
    mode    => 0755,
    require => [File['/var/avalon'],User['avalondrop']]
  }

  file { '/var/avalon/hls_streams':
  	ensure  => directory,
  	owner   => 'avalon',
  	group   => 'avalon',
  	mode    => 0775,
	require => [File['/var/avalon'],User['avalon']]
  }

  augeas { "sshd_config":
    context => "/files/etc/ssh/sshd_config",
    changes => [
      "set Subsystem/sftp 'internal-sftp'",
      "set Match[Condition/Group='dropbox']/Condition/Group 'dropbox'",
      "set Match[Condition/Group='dropbox']/Settings/ChrootDirectory '/var/avalon'",
      "set Match[Condition/Group='dropbox']/Settings/X11Forwarding 'no'",
      "set Match[Condition/Group='dropbox']/Settings/AllowTcpForwarding 'no'",
      "set Match[Condition/Group='dropbox']/Settings/ForceCommand 'internal-sftp'"
    ],
    notify => Service["sshd"],
  }

  service { "sshd":
    name => $operatingsystem ? {
      Debian => "ssh",
      default => "sshd",
    },
    require => Augeas["sshd_config"],
    enable => true,
    ensure => running,
  }
}
