# Copyright 2011-2013, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
# 
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed 
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the 
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

class solr::install (
  
  $solr           = $solr::params::solr_version,
  $tomcat_webapps = $solr::params::tomcat_webapps,
)  inherits solr::params {
  include solr::config
  include staging

  staging::file { "solr-$solr.tgz":
    source  => "http://archive.apache.org/dist/lucene/solr/$solr/solr-$solr.tgz",
    timeout => 1200,
    subdir  => solr,
    ##TODO Should probably go into a tomcat module specific to our tomcat package
    require => Class['tomcat'],
    notify  => Service['tomcat'],
  }

  staging::extract { "solr-$solr.tgz":
    target  => "${staging::path}/solr",
    creates => "${staging::path}/solr/solr-$solr",
    require => Staging::File["solr-$solr.tgz"],
  }

  file { "$solr_home/solr.war":
    source  => "${staging::path}/solr/solr-$solr/dist/solr-$solr.war",
    owner   => tomcat7,
    group   => tomcat,
    require => [Staging::Extract["solr-$solr.tgz"],File[$solr_home]],
  }

  file { ["$solr_home/lib", "$solr_home/lib/contrib"]:
    ensure  => directory,
    owner   => tomcat7,
    group   => tomcat,
    require => [Staging::Extract["solr-$solr.tgz"],File[$solr_home]],
  }   

  class { 'solr::contrib':
    solr    => $solr,
    require => [Staging::Extract["solr-$solr.tgz"],File[$solr_home],File["$solr_home/lib/contrib"]],
  }
}
