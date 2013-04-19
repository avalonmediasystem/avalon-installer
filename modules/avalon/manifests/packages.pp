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

class avalon::packages {
  include mediainfo
  
  package { ['cronie', 'curl', 'sqlite-devel', 'mysql-devel', 'v8-devel', 'zip', 'libyaml-devel', 'libffi-devel', 'lsof']:
    ensure  => present,
    require => [Class['epel'],Class['nulrepo']],
  }

  service { 'crond':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    subscribe  => Package['cronie']
  }

}
