class avalon::security::adobe {
  include avalon::security
  
  staging::file { "ams-avalon.tar.gz":
    source  => "puppet:///modules/avalon/ams/ams-avalon.tar.gz",
    subdir  => ams,
  }

  staging::extract { "ams-avalon.tar.gz":
    target  => '/opt/adobe/ams/applications/',
    subdir  => ams,
    creates => '/usr/local/red5/webapps/avalon',
    require => [Staging::File["ams-avalon.tar.gz"]]
  }

  service { "ams": 
    ensure => running,
    enable => true,
  }

  exec { "add Avalon config to ams.ini":
    command => 'printf "\n\nAVALON.AUTH_URL = ${avalon::info::avalon_url}/authorize\nAVALON.STREAM_PATH = /opt/adobe/ams/webroot/avalon\n" >> ams.ini',
    cwd     => '/opt/adobe/ams/conf',
    unless  => "grep '${avalon::info::avalon_url}/authorize' ams.ini"
  }

  file { '/opt/adobe/ams/Apache2.2/conf/avalon.conf':
    content => template('avalon/security/avalon_httpd_ams.conf.erb'),
    mode    => 0755
  }

  exec { 'printf "\n\nInclude conf/avalon.conf\n" >> httpd.conf': 
    cwd     => '/opt/adobe/ams/Apache2.2/conf/',
    unless  => "grep avalon.conf httpd.conf"
  }

  file { '/opt/adobe/ams/webroot/avalon':
    ensure  => link,
    force   => true,
    target  => "${avalon::info::root_dir}/rtmp_streams"
  }
}