class avalon::content {
  include concat::setup

  Mount {
    fstype  => "nfs",
    ensure  => "mounted",
    options => "defaults",
    atboot  => "true",
  }

  package { ["nfs-utils"]:
      ensure => latest,
  }

  service { "nfslock":
      ensure => running,
      enable => true,
      require => [
          Package["nfs-utils"]
      ],
  }

  service { "nfs":
      ensure => running,
      enable => true,
      require => Service["nfslock"],
  }

  concat { '/etc/exports': 
    notify => Service['nfs']
  }

  concat::fragment { 'export-comment':
    content => "# Avalon exports\n",
    target  => '/etc/exports'
  }
}