class avalon::web {
  include apache
  include rvm

  group { 'avalon':
    ensure     => present
  }

  user { 'avalon':
    ensure     => present,
    gid        => 'avalon',
    managehome => true,
    require    => Group['avalon']
  }

  exec { "/usr/sbin/usermod -a -G avalon red5":
    unless  => "/bin/cat /etc/group | grep ^avalon | grep red5",
    require => [User['red5'], Group['avalon']];
  }

  exec { "/usr/sbin/usermod -a -G avalon matterhorn":
    unless  => "/bin/cat /etc/group | grep ^avalon | grep matterhorn",
    require => [User['matterhorn'], Group['avalon']];
  }

  ssh_authorized_key { 'vagrant_key_shared_with_avalon':
    ensure => present,
    user   => 'avalon',
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==',
    type   => 'ssh-rsa',
  }

  ssh_authorized_key { 'avalon_key_for_capistrano_deploy':
    ensure => present,
    user   => 'avalon',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC5u3clpfgbu1gwMDSXvUc6+cqsDNBwUMNwNGklJjVsFMbX36y9izY2/tK4mNBxJNW1Tek1O/nwkrbIoxaIzPLQS+nyf/Sz05wY3cUfSIptJazI82pu4lNtUK51RruRjsw49yzoUfMwHSetPqC+TgipNHo4QdizzVe9l0koznNeDtNm+JmlvdV78Dwrc6VFfaVwAOvXw2MMxvma1Ow58W648c/H9EDnr9YvILon1t3mqcEXlhPaRmbZe4IyYaeCRitIbKa+Twxw2VVSDAi7U2YhXYDUC2yIH2lcL+kSmHG+CYfuxsK9PmU1yHNzcWr9obXqXTSzi389k7EK60np7kDN',
    type   => 'ssh-rsa'
  }
  
  file { ['/var/www', '/var/www/avalon']:
    ensure  => 'directory',
    owner   => 'avalon',
    group   => 'avalon',
    mode    => 755,
  }

  file{ '/var/www/avalon/shared':
    source  => 'puppet:///local/avalon/shared',
    owner   => 'avalon',
    group   => 'avalon',
    recurse => true
  }

  file{ ['/var/www/avalon/shared/log', '/var/www/avalon/shared/pids']:
    ensure  => 'directory',
    owner   => 'avalon',
    group   => 'avalon',
  }

  rvm::system_user { avalon: ; }

  rvm_system_ruby {
    'ruby-1.9.3-p392':
      ensure      => 'present',
      default_use => true,
      require     => Class['avalon::packages']
  }

  rvm_gemset {
    'ruby-1.9.3-p392@avalon':
      ensure  => present,
      require => Rvm_system_ruby['ruby-1.9.3-p392'],
  }

  rvm_gem {
    'ruby-1.9.3-p392@avalon/bundler':
      require => Rvm_gemset['ruby-1.9.3-p392@avalon'],
  }

  class { 'rvm::passenger::apache':
    version => '3.0.19',
    ruby_version => 'ruby-1.9.3-p392',
    mininstances => '3',
    maxinstancesperapp => '0',
    maxpoolsize => '30',
    spawnmethod => 'smart-lv2';
  }

  apache::vhost { 'avalon.dev':
    serveraliases   => ['*'],
    priority        => '10',
    port            => '80',
    docroot         => '/var/www/avalon/current/',
    passenger       => true,
    # rvm has a dependency for mod_ssl
    ssl             => false,
  }


}

