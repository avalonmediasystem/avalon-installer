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

class avalon::params {
  $ruby_version           = $rvm_latest_ruby
  $source_branch          = "develop"
  $deploy_tag             = "bare-deploy"
  $dropbox_user           = $avalon_dropbox_user
  $dropbox_password_hash  = $avalon_dropbox_password_hash
  $database_name          = "avalonweb"
  $database_user          = $avalon_db_user
  $database_pass          = $avalon_db_password
  $database_host          = $avalon_db_host
  $public_address         = $avalon_public_address
  $public_port            = "80"
  $public_url             = $avalon_public_url
}
