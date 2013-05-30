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

class avalon::info {
  $avalon_address         = hiera('avalon_address', $avalon_hostname)
  $avalon_url             = hiera('avalon_url', "http://${avalon_address}")
  $matterhorn_address     = hiera('matterhorn_address', $avalon_address)
  $matterhorn_url         = hiera('matterhorn_url', "http://${matterhorn_address}:8080")
  $rtmp_url               = hiera('rtmp_url', "rtmp://${avalon_address}/avalon")
  $hls_url                = hiera('hls_url', "http://${avalon_address}/streams")
  $db_address             = hiera('db_address', $avalon_address)
  $tomcat_url             = hiera('db_url', "http://${db_address}:8983")
  $dropbox_user           = hiera('dropbox_user')
  $dropbox_password_hash  = hiera('dropbox_password_hash')
  $admin_user             = hiera('admin_user')
  $root_dir               = hiera('root_dir', "/var/avalon")
  $rails_env              = hiera('rails_env', "production")
  $ldap_bind_dn           = hiera('ldap_bind_dn')
  $ldap_password          = hiera('ldap_password')
}