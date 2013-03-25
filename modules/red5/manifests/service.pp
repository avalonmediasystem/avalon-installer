class red5::service {

  service { 'red5':
    name       => 'red5',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    subscribe  => [File['/usr/local/red5'],File['/etc/init.d/red5']],
    require    => [Class['red5::install']]
  }

}
