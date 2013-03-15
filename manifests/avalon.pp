class avalon {
  include epel
  include nulrepo
  include apache
  include matterhorn
  include tomcat
  include mysql
  include avalon::framework
  }



  class { "fcrepo::config":
    fedora_base => "/usr/local",
    fedora_home => "/usr/local/fedora",
    tomcat_home => "/usr/local/tomcat",
    server_host => "localhost",
    user        => "tomcat7",
    require     => Class['tomcat'],
  }

  #include fcrepo::derby
  #heirafy
  include fcrepo::mysql

  class { fcrepo:
    require => Class['tomcat'],
  }

  class { solr:
    require => Class['tomcat'],
  }

  class { tomcat:
    require => Class['nulrepo'],
  }


  include avalon::framework
  include solr

  # TODO: Solr
  # TODO: Matterhorn
  # TODO: Webapp
         #apache
         #passenger

  include avalon
