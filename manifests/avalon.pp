class avalon {
  include epel
  include nulrepo
  include apache
  include concat::setup
  include matterhorn
  include tomcat
  include fcrepo::config
  include avalon::packages
  include avalon::web
  include avalon::framework
  include solr
  include fcrepo::mysql
}

include avalon 
