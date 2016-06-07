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

class solr::config (
  $tomcat_webapps      = $solr::params::tomcat_webapps,
  $tomcat_webapps_conf = $solr::params::tomcat_webapps_conf,
  $user                = $solr::params::user,
  $group               = $solr::params::group,
  $version             = $solr::params::solr_version,
  $solr_base           = $solr::params::solr_base,
  $solr_home           = $solr::params::solr_home,
  $solr_conf           = "$solr::params::solr_home/conf",
  $solr_xml            = $solr::params::solr_xml,


) inherits solr::params {

  File {
    selinux_ignore_defaults => true
  }

  file { 'solr.xml':
    ensure  => file,
    owner   => $user,
    group   => $group,
    content => template('solr/solr.xml.erb'),
    path    => "$tomcat_webapps_conf/solr.xml",
    require => Class['solr::install'],
  }
  
  file { "$solr_home":
    ensure  => directory,
    owner   => $user,
    group   => $group,
  }

  file {'/usr/local/solr/solr.xml':
    ensure  => present,
    owner   => $user,
    group   => $group,
    source  => 'puppet:///modules/solr/solr.xml',
    require => File["$solr_home"],
  }

  file { 'solr_avalon':
    ensure  => directory,
    owner   => $user,
    group   => $group,
    path    => "$solr_home/avalon",
    require => File["$solr_home"],
  }
  
  file { 'solr_conf_avalon':
    ensure  => directory,
    path    => "$solr_home/avalon/conf",
    source  => 'puppet:///modules/solr/avalon/conf',
    owner   => $solr::params::user,
    group   => $solr::params::group,
    recurse => true,
    replace => true,
    require => [File['solr_avalon'],File["$solr_home/solr.war"],Class['tomcat::service']],
  }
  ~>
  exec { 'reload-avalon-core':
    command => "/usr/bin/curl 'http://localhost:8983/solr/admin/cores?action=RELOAD&core=avalon'"
  }

  file { 'solr_mhorn':
    ensure  => directory,
    owner   => $user,
    group   => $group,
    path    => "$solr_home/mhorn",
    require => File["$solr_home"],
  }
  
  file { 'solr_conf_mhorn':
    ensure  => directory,
    path    => "$solr_home/mhorn/conf",
    source  => 'puppet:///modules/solr/mhorn/conf',
    owner   => $solr::params::user,
    group   => $solr::params::group,
    recurse => true,
    require => [File['solr_mhorn'],File["$solr_home/solr.war"],Class['tomcat::service']],
  }
}
