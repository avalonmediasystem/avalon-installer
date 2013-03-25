class avalon::security(
  $stream_base   = $avalon::security::stream_base,
  $avalon_server = $avalon::security::avalon_server,
  $adobe_hls     = $avalon::security::adobe_hls,
  $stream_dir    = $avalon::security::stream_dir,
  $server_home   = $avalon::security::server_home
) inherits avalon::security::params {

  staging::file { "red5-avalon.tar.gz":
    source  => "puppet:///local/red5/red5-avalon.tar.gz",
    subdir  => red5,
  }

  staging::extract { "red5-avalon.tar.gz":
    target  => '/usr/local/red5/webapps',
    subdir  => red5,
    notify  => File['red5-permissions'],
    creates => '/usr/local/red5/webapps/avalon',
    require => [Staging::File["red5-avalon.tar.gz"]]
  }

  file { '/usr/local/red5/webapps/avalon/WEB-INF/red5-web.properties':
    content => template('avalon_red5_web.properties.erb'),
    require => Staging::Extract["red5-avalon.tar.gz"]
  }

  file { '/usr/local/sbin':
    ensure => directory
  }

  file { '/usr/local/sbin/avalon_auth':
    content => template('avalon_auth.sh.erb'),
    require => File['/usr/local/sbin']
  }

#  file { '/etc/httpd/conf.d/avalon_hls_security.conf': 
#    content => template('avalon_httpd.conf.erb'),
#    notify  => Service['httpd'],
#    require => [File['/usr/local/sbin/avalon_auth']]
#  }

}