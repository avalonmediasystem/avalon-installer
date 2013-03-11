class avalon {
  include epel
  include nulrepo
  include apache
  }

  exec { 'passenger_gem_install':
    user    => 'vagrant',
    command => 'gem install passenger',
    unless  => 'gem list passenger | grep passenger',
    path    => ['/home/vagrant/.rbenv/shims',
                '/home/vagrant/.rbenv/bin',
                '/usr/local/bin',
                '/bin', '/usr/bin', '/usr/local/sbin',
                '/usr/sbin','/sbin','/home/vagrant/bin',],
    require => Rbenv::Compile ["1.9.3-p392"],
  }


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
         #apache
         #passenger

  include avalon
