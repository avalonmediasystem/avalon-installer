class avalon::security(
  $stream_base   = $avalon::security::params::stream_base,
  $avalon_server = $avalon::security::params::avalon_server,
  $adobe_hls     = $avalon::security::params::adobe_hls,
  $stream_dir    = $avalon::security::params::stream_dir,
  $server_home   = $avalon::security::params::server_home
) inherits avalon::security::params {

  staging::file { "red5-avalon.tar.gz":
    source  => "puppet:///local/red5/red5-avalon.tar.gz",
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
    content => template('avalon_red5_web.properties.erb'),
    require => Staging::Extract["red5-avalon.tar.gz"]
  }

  file { '/usr/local/sbin':
    ensure  => directory
  }

  file { '/usr/local/sbin/avalon_auth':
    content => template('avalon_auth.sh.erb'),
    mode    => 0755,
    require => File['/usr/local/sbin']
  }

  file { '/usr/local/red5/webapps/avalon/streams':
    ensure  => directory,
    owner   => 'red5',
    group   => 'avalon',
    mode    => 0775,
    require => Staging::Extract['red5-avalon.tar.gz']
  }

  file { '/var/avalon/rtmp_streams':
    ensure  => link,
    force   => true,
    target  => '/usr/local/red5/webapps/avalon/streams',
    require => File['/usr/local/red5/webapps/avalon/streams']
  }

  file { '/etc/httpd/conf.d/05-mod_rewrite.conf': 
    ensure  => present,
    source  => 'puppet:///local/avalon/mod_rewrite.conf'
  }

}