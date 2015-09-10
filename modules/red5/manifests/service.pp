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

class red5::service {

  service { 'red5':
    name       => 'red5',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    subscribe  => [File['/usr/local/red5'],File['/etc/init.d/red5'],File['/etc/sysconfig/red5']],
    require    => [Class['red5::install']]
  }

}
