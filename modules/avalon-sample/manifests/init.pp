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

class avalon-sample(
  $rpm_location = "http://www.avalonmediasystem.org/downloads/avalon-sample-content.noarch.rpm",
  $timeout      = 2400
) {
  include avalon
  include tomcat

  exec {"avalon-sample-content":
    command => "/bin/rpm -i \"${rpm_location}\"",
    unless => '/bin/rpm -q avalon-sample-content',
    environment => ["RAILS_ENV=${rails_env}"],
    timeout => $timeout,
    require => [Class['avalon'], Service['tomcat'], Class['avalon::security']] #Avalon has to be installed and fedora/solr running
  }
}
