class red5::install {
  staging::file { "red5-1.0.1.tar.gz":
    source  => "http://red5.org/downloads/red5/1_0_1/red5-1.0.1.tar.gz",
    timeout => 1200,
    subdir  => red5,
  }

  group { 'red5':
    ensure => present
  }

  user { 'red5':
    ensure => present,
    gid => 'red5',
    require => Group['red5']
  }

  staging::extract { "red5-1.0.1.tar.gz":
    target  => '/usr/local/',
    creates => "/usr/local/red5-server-1.0",
    require => [Staging::File["red5-1.0.1.tar.gz"],User['red5']],
  }

  file { "/usr/local/red5-server-1.0":
    owner   => 'red5',
    group   => 'red5',
    recurse => true,
    require => Staging::Extract["red5-1.0.1.tar.gz"]
  }

  file { "/usr/local/red5":
    ensure => link,
    target => '/usr/local/red5-server-1.0',
    require => File["/usr/local/red5-server-1.0"]
  }

  file { "/etc/init.d/red5":
    ensure => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
    content => template("red5/red5_init_script.erb")
  }
}
