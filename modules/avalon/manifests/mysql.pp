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

class avalon::mysql {
  include avalon::mysql::params
  include staging
  
  class { '::mysql::server':
    override_options => { 
      mysqld => { bind_address => '0.0.0.0' }
    }
  }

  mysql::db { 'avalonweb':
    user     => $avalon::mysql::params::username,
    password => $avalon::mysql::params::password,
    host     => $avalon::mysql::params::hostname,
    grant    => $avalon::mysql::params::grant,
    require  => $avalon::mysql::params::require
  }

  mysql::db { 'matterhorn':
    user     => $avalon::mysql::params::username,
    password => $avalon::mysql::params::password,
    host     => $avalon::mysql::params::hostname,
    grant    => $avalon::mysql::params::grant,
    require  => $avalon::mysql::params::require
  }

  staging::file { 'matterhorn.sql':
    subdir    => 'avalon',
    source    => 'puppet:///modules/avalon/matterhorn_schema_mysql5.sql'
  }

  $mysql_mhorn = "/usr/bin/mysql --user=${avalon::mysql::params::username} --password=${avalon::mysql::params::password} matterhorn"

  database_user { "${avalon::mysql::params::username}@${avalon::mysql::params::hostname}":
    ensure        => present,
    password_hash => mysql_password($avalon::mysql::params::password)
  }->
  mysql_grant { "${avalon::mysql::params::username}@${avalon::mysql::params::hostname}/matterhorn":
    ensure     => present,
    options    => ['GRANT'],
    privileges => ['all'],
    table      => '*.*',
    user       => "${avalon::mysql::params::username}@${avalon::mysql::params::hostname}"
  }->
  exec { 'create matterhorn tables':
    command   => "${mysql_mhorn} < ${staging::path}/avalon/matterhorn.sql",
    unless    => "${mysql_mhorn} -e 'show tables;' 2>&1 | grep 'mh_service_registration'",
    require   => [Mysql::Db['matterhorn'],Staging::File['matterhorn.sql']]
  }

}
