class avalon {
  include epel
  include nulrepo
  include apache
  }



  package { "tomcat":
    ensure  =>  installed,
    require => Class['nulrepo'],
  }

  class { "fcrepo::config":
    fedora_base => "/usr/local",
    fedora_home => "/usr/local/fedora",
    tomcat_home => "/usr/local/tomcat",
    server_host => "localhost",
    user        => "tomcat7"
  }

  #include fcrepo::derby
  include fcrepo::mysql

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
         #apache
         #passenger

  include avalon
