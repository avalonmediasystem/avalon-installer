class avalon::security::red5 {
  include avalon::security
  
  staging::file { "red5-avalon.tar.gz":
    source  => "puppet:///modules/avalon/red5/red5-avalon.tar.gz",
    subdir  => red5,
  }

  staging::extract { "red5-avalon.tar.gz":
    target  => '/usr/local/red5/webapps',
    subdir  => red5,
#    notify  => File['red5-permissions'],
    creates => '/usr/local/red5/webapps/avalon',
    require => [Staging::File["red5-avalon.tar.gz"],Class['red5::install']]
  }

  file { '/usr/local/red5/webapps/avalon/WEB-INF/red5-web.properties':
    content => template('avalon/security/avalon_red5_web.properties.erb'),
    require => Staging::Extract["red5-avalon.tar.gz"]
  }

  file { "${avalon::info::root_dir}/rtmp_streams":
    ensure  => link,
    force   => true,
    target  => '/usr/local/red5/webapps/avalon/streams',
    require => File['/usr/local/red5/webapps/avalon/streams']
  }

  file { '/usr/local/red5/webapps/avalon/streams':
    ensure  => directory,
    owner   => 'red5',
    group   => 'avalon',
    mode    => 0775,
    require => Staging::Extract['red5-avalon.tar.gz']
  }

  file { '/etc/httpd/conf.d/05-mod_rewrite.conf': 
    ensure  => present,
    source  => 'puppet:///modules/avalon/mod_rewrite.conf',
    notify  => Service['httpd'],
    require => File['/usr/local/sbin/avalon_auth'],
  }
}