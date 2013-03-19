class avalon {
  include epel
  include nulrepo
  include apache
  include matterhorn
  include tomcat
  include avalon::packages
  include avalon::web
  include avalon::framework
  include solr
  include concat::setup
  include fcrepo::mysql
}

  include avalon 
  

 
  
  #  class { nulrepo:
  #  require => Class['epel'],
  #}

  #    class { 'fcrepo::config':
  #      fedora_base => '/usr/local',
  #      fedora_home => '/usr/local/fedora',
  #      tomcat_home => '/usr/local/tomcat',
  #      server_host => 'localhost',
  #      user        => 'tomcat7',
  #      dbtype      => 'mysql',
  #      require     => Class['tomcat'],
  #    }
  #
