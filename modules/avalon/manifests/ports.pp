class avalon::ports {
  class { '::firewall': }

  resources { "firewall": 
    purge => true
  }

  class { ['avalon::ports::pre','avalon::ports::post']: }
}

class avalon::ports::web {
  firewall { '100 accept all http':
    proto   => tcp,
    port    => 80,
    action  => accept
  }
}

class avalon::ports::tomcat {
  firewall { '101 accept 8983 from web and matterhorn':
    proto   => tcp,
    port    => 8983,
    source  => [$avalon::info::avalon_address, $avalon::info::matterhorn_address],
    action  => accept
  }
}

class avalon::ports::db {
  firewall { '102 accept mysql from web and matterhorn':
    proto   => tcp,
    port    => 3306,
    source  => [$avalon::info::avalon_address, $avalon::info::matterhorn_address],
    action  => accept
  }
}

class avalon::ports::matterhorn {
  firewall { '103 accept all 8080':
    proto   => tcp,
    port    => 8080,
    action  => accept
  }
}

class avalon::ports::rtmp {
  firewall { '104 accept all 1935':
    proto   => tcp,
    port    => 1935,
    action  => accept
  }
}

class avalon::ports::dropbox {
  firewall { '105 accept all sftp':
    proto   => tcp,
    port    => 22,
    action  => accept
  }
}

class avalon::ports::export {
  firewall { '200 accept nfs tcp':
    proto   => tcp,
    port    => [111,1110,2049,4045],
    action  => accept
  }->
  firewall { '201 accept nfs udp':
    proto   => udp,
    port    => [111,1110,2049,4045],
    action  => accept
  }
}

class avalon::ports::pre {
  Firewall { require => undef }
  firewall { '000 accept all icmp':
    proto   => 'icmp',
    action  => 'accept',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 accept related established rules':
    proto   => 'all',
    state   => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }->
  firewall { '003 accept ssh from NU':
    proto   => 'all',
    source  => '129.105.0.0/16',
    action  => 'accept'
  }->
  firewall { '004 accept ssh from NU SSL VPN':
    proto   => 'all',
    source  => '165.124.200.24/29',
    action  => 'accept'
  }->
  firewall { '005 accept all from vbox NAT':
    proto   => 'all',
    iniface => 'eth0',
    action  => 'accept'
  }
}

class avalon::ports::post {
  Firewall { require => undef }
  firewall { '999 drop all':
    proto   => 'all',
    action  => 'drop',
    before  => undef,
  }
}
