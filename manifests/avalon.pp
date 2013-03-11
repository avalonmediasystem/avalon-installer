class avalon {
  include epel
  include nulrepo
  
  package { "tomcat": ensure => installed }

  class { "fcrepo::config":
    fedora_base => "/usr/local",
    fedora_home => "/usr/local/fedora",
    tomcat_home => "/usr/local/tomcat",
    server_host => "localhost",
    user        => "tomcat7"
  }

  include fcrepo::derby
  
  class { fcrepo:
    require => Package['tomcat']
  }

  service { 'tomcat':
    name       => 'tomcat',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Class['fcrepo']
  }

  include avalon::framework
  include solr
  include matterhorn

  # TODO: Solr
  # TODO: Matterhorn
  # TODO: Webapp
}

include avalon
