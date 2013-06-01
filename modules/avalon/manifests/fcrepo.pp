class avalon::fcrepo {
  class { ::fcrepo: 
    require => [Class['fcrepo::config'], Class['fcrepo::mysql'], Package['tomcat']] 
  }
}
