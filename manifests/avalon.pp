class avalon {
  include epel
  include nulrepo
  
  package { "tomcat": }

  class { "fedora::config":
    fedora_base => "/usr/local",
    fedora_home => "/usr/local/fedora",
    tomcat_home => "/usr/local/tomcat",
    server_host => "localhost",
    user        => "tomcat7"
  }

  include fedora::derby
  
  class { fedora:
    require => Package['tomcat']
  }

  service { 'tomcat':
    name       => 'tomcat',
    ensure     => true,
    enable     => true,
    hasrestart => true,
    require    => Class['fedora']
  }
  include avalon::framework
  # TODO: Solr
  # TODO: Matterhorn
  # TODO: Webapp
}

include avalon