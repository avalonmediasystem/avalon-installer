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

class solr::contrib (
  $solr = $solr::params::solr_version
) inherits solr::params {
  File { 
    owner   => tomcat7,
    group   => tomcat,
    selinux_ignore_defaults => true,
    require => [Staging::Extract["solr-$solr.tgz"],File[$solr_home],File["$solr_home/lib/contrib"]]
  }

  file { "$solr_home/lib/solr-analysis-extras-$solr.jar":
    ensure => present,
    source => "${staging::path}/solr/solr-$solr/dist/solr-analysis-extras-$solr.jar"
  }

  file { "$solr_home/lib/solr-clustering-$solr.jar":
    ensure => present,
    source => "${staging::path}/solr/solr-$solr/dist/solr-clustering-$solr.jar"
  }

  file { "$solr_home/lib/solr-langid-$solr.jar":
    ensure => present,
    source => "${staging::path}/solr/solr-$solr/dist/solr-langid-$solr.jar"
  }

  file { "$solr_home/lib/contrib/analysis-extras":
    ensure  => present,
    recurse => true,
    source  => "${staging::path}/solr/solr-$solr/contrib/analysis-extras"
  }

  file { "$solr_home/lib/contrib/clustering":
    ensure  => present,
    recurse => true,
    source  => "${staging::path}/solr/solr-$solr/contrib/clustering"
  }

  file { "$solr_home/lib/contrib/langid":
    ensure  => present,
    recurse => true,
    source  => "${staging::path}/solr/solr-$solr/contrib/langid"
  }
}
