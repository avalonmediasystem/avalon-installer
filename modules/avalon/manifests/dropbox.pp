class avalon::dropbox {
  include stdlib

  if $avalon::info::dropbox_password_hash =~ /^$/  {
    fail("Missing info: avalon::info::dropbox_password")
  }
  
#  group { 'dropbox':
#    ensure => present,
#    system => true
#  }

  user { $avalon::info::dropbox_user:
    ensure   => present,
    system   => true,
    gid      => 'dropbox',
    home     => '/dropbox', # because it's already chrooted to $avalon::info::root_dir
    password => $avalon::info::dropbox_password_hash,
    require  => Group['dropbox']
  }

  file { "${avalon::info::root_dir}/dropbox":
    ensure  => directory,
    owner   => $avalon::info::dropbox_user,
    group   => 'dropbox',
    mode    => 2775,
    require => [File[$avalon::info::root_dir],User[$avalon::info::dropbox_user]]
  }

  augeas { "sshd_config":
    context => "/files/etc/ssh/sshd_config",
    changes => [
      "set Subsystem/sftp 'internal-sftp'",
      "set Match[Condition/User='${avalon::info::dropbox_user}']/Condition/User '${avalon::info::dropbox_user}'",
      "set Match[Condition/User='${avalon::info::dropbox_user}']/Settings/ChrootDirectory '${avalon::info::root_dir}'",
      "set Match[Condition/User='${avalon::info::dropbox_user}']/Settings/AllowTcpForwarding 'no'",
      "set Match[Condition/User='${avalon::info::dropbox_user}']/Settings/ForceCommand 'internal-sftp'"
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