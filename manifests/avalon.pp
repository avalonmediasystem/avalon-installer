class avalon {
  include epel
  include nulrepo
  include apache
  include concat::setup
  include matterhorn
  class { tomcat::install: 
    http_port => '8983'
  }
  include tomcat
  class { fcrepo::config: 
    user => 'tomcat7', 
    server_host => 'localhost' 
  }
  include fcrepo::mysql
  class { fcrepo: 
  	require => [Class['fcrepo::config'], Class['fcrepo::mysql'], Package['tomcat']] 
  }
  include solr
  include red5
  include avalon::packages
  include avalon::web
  include avalon::framework
}

include avalon 
