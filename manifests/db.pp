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

include epel
include nulrepo
include avalon::info
class { tomcat::install: 
  http_port => '8983'
}
include tomcat
class { avalon::mysql::params:
  host => '%'
}
include avalon::mysql
class { fcrepo::config: 
  user => 'tomcat7', 
  server_host => 'localhost' 
}
class { fcrepo: 
  require => [Class['fcrepo::config'], Class['fcrepo::mysql'], Package['tomcat']] 
}
include fcrepo::mysql
include solr
