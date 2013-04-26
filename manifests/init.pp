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
class { matterhorn::config:
  http_port => '18080'
}
include matterhorn
class { tomcat::install: 
  http_port => '8983'
}
include tomcat
class { fcrepo::config: 
  user => 'tomcat7', 
  server_host => 'localhost' 
}
include fcrepo::mysql
class { fcrepo: 
	require => [Class['fcrepo::config'], Class['fcrepo::mysql'], Package['tomcat']] 
}
include solr
include red5
class { avalon::web:
  source_branch => 'release/1.0.0'
}
include avalon
