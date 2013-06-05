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

  concat { '/opt/adobe/ams/conf/ams.ini': 
    notify => Service['ams']
  }

  concat::fragment { 'avalon-config':
    content => "\n\nAVALON.AUTH_URL = ${avalon::info::avalon_url}/authorize\nAVALON.STREAM_PATH = /opt/adobe/ams/webroot/avalon\n",
    target  => '/opt/adobe/ams/conf/ams.ini',
    unless  => 'grep AVALON.AUTH_URL /opt/adobe/ams/conf/ams.ini'
  }

  file { '/opt/adobe/ams/Apache2.2/conf/avalon.conf':
    content => template('avalon/security/avalon_httpd_ams.conf.erb'),
    mode    => 0755
  }

  concat { '/opt/adobe/ams/Apache2.2/conf/httpd.conf':
    notify  => Service['httpd'],
    require => File['/opt/adobe/ams/Apache2.2/conf/avalon.conf']
  }

  concat::fragment { 'avalon-httpd-include':
    content => "\nInclude conf/avalon.conf",
    target  => '/opt/adobe/ams/Apache2.2/conf/httpd.conf',
    unless  => 'grep avalon.conf /opt/adobe/ams/Apache2.2/conf/httpd.conf'
  }

  file { '/opt/adobe/ams/webroot/avalon':
    ensure  => link,
    force   => true,
    target  => "${avalon::info::root_dir}/rtmp_streams"
  }

  file { '/etc/httpd/conf.d/05-mod_rewrite.conf': 
    ensure  => present,
    source  => 'puppet:///modules/avalon/mod_rewrite.conf',
    notify  => Service['httpd'],
    require => File['/usr/local/sbin/avalon_auth'],
  }
}