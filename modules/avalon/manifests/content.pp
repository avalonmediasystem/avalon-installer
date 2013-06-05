class avalon::content {
  include concat::setup

  package { ["nfs-utils"]:
      ensure => latest,
  }

  service { "rpcbind": 
      ensure => running,
      enable => true,
      require => [
          Package["nfs-utils"]
      ],
  }

  service { "nfslock":
      ensure => running,
      enable => true,
      require => [
          Service["rpcbind"]
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
