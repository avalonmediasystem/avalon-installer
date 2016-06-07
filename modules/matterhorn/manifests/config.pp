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

class matterhorn::config (

  $matterhorn_user  = 'matterhorn',
  $matterhorn_base  = '/usr/local/matterhorn',
  $matterhorn_admin = 'library@northwestern.edu',
  $public_url       = $matterhorn_public_url,
  $rtmp_dir         = '/var/avalon/rtmp_streams',
  $hls_dir          = '/var/avalon/hls_streams',
  $http_port        = '8080',
  $nproc_limit      = '4096'

) {
  include firewall

  File { require => Class['matterhorn::install'], }
  
  #init script
  file { '/etc/rc.d/init.d/matterhorn':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
    content => template("matterhorn/matterhorn_init.erb"),
  }

  #nproc configuration 
  file { '/etc/security/limits.d/99-matterhorn.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template("matterhorn/99-matterhorn.conf.erb"),
  }

  #config.properties
  file { "$matterhorn_base/etc/config.properties":
    ensure  => present,
    content => template("matterhorn/config.properties.erb"),
    owner   => 'matterhorn',
    group   => 'matterhorn',
    replace => false,
  }

  firewall { '110 allow matterhorn access':
    port   => $http_port,
    proto  => tcp,
    action => accept,
  }
}
