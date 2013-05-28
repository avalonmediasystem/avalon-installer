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

class avalon::security(
  $stream_base   = $avalon::security::params::stream_base,
  $avalon_server = $avalon::security::params::avalon_server,
  $adobe_hls     = $avalon::security::params::adobe_hls,
  $stream_dir    = $avalon::security::params::stream_dir,
  $server_home   = $avalon::security::params::server_home
) inherits avalon::security::params {

  staging::file { "red5-avalon.tar.gz":
    source  => "puppet:///modules/avalon/red5/red5-avalon.tar.gz",
    subdir  => red5,
  }

  staging::extract { "red5-avalon.tar.gz":
    target  => '/usr/local/red5/webapps',
    subdir  => red5,
#    notify  => File['red5-permissions'],
    creates => '/usr/local/red5/webapps/avalon',
    require => [Staging::File["red5-avalon.tar.gz"],Class['red5::install']]
  }

  file { '/usr/local/red5/webapps/avalon/WEB-INF/red5-web.properties':
    content => template('avalon/security/avalon_red5_web.properties.erb'),
    require => Staging::Extract["red5-avalon.tar.gz"]
  }

  file { '/usr/local/sbin':
    ensure  => directory
  }

  file { '/usr/local/sbin/avalon_auth':
    content => template('avalon/security/avalon_auth.sh.erb'),
    mode    => 0755,
    require => File['/usr/local/sbin']
  }

  file { '/usr/local/red5/webapps/avalon/streams':
    ensure  => directory,
    owner   => 'red5',
    group   => 'avalon',
    mode    => 0775,
    require => Staging::Extract['red5-avalon.tar.gz']
  }

  file { "$avalon_root_dir/rtmp_streams":
    ensure  => link,
    force   => true,
    target  => '/usr/local/red5/webapps/avalon/streams',
    require => File['/usr/local/red5/webapps/avalon/streams']
  }

  file { '/etc/httpd/conf.d/05-mod_rewrite.conf': 
    ensure  => present,
    source  => 'puppet:///modules/avalon/mod_rewrite.conf',
    notify  => Service['httpd'],
    require => File['/usr/local/sbin/avalon_auth'],
  }

}
