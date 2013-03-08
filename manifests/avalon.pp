class avalon {
  include epel
  include nulrepo
  
  class { "fedora::derby":
    fedora_home => "/usr/local/avalon/fedora",
  }

  class { "fedora":
    fedora_base => "/usr/local/avalon",
    fedora_home => "/usr/local/avalon/fedora",
    tomcat_home => "/usr/local/tomcat",
    server_host => "localhost",
    user => "tomcat7"
  }

  # TODO: Solr
  # TODO: Matterhorn
  # TODO: Webapp
}

include avalon