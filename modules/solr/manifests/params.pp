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

class solr::params {
  $solr_version         = '4.2.0'
  $tomcat_webapps       = '/usr/local/tomcat/webapps'
  $tomcat_webapps_conf  = '/usr/local/tomcat/conf/Catalina/localhost/'
  $tomcat_root          = '/usr/local/tomcat'
  $user                 = 'tomcat7'
  $group                = 'tomcat'
  $solr_home            = '/usr/local/solr'
  $server_host          = $::fqdn
  $tomcat_http_port     = '8080'
  $tomcat_https_port    = '8443'
  $java_version         = '1.7.0'
  $tomcat_shutdown_port = '8005'
  $solr_context         = 'solr'

}
