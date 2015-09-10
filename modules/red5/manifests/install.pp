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

class red5::install {
  include firewall
  
  File {
    selinux_ignore_defaults => true
  }

  staging::file { "red5-1.0.1.tar.gz":
    source  => "http://yumrepo-public.library.northwestern.edu/red5-1.0.1.tar.gz",
    timeout => 1200,
    subdir  => red5,
  }

  group { 'red5':
    ensure  => present,
    system  => true,
  }

  user { 'red5':
    ensure  => present,
    gid     => 'red5',
    system  => true,
    shell   => '/sbin/nologin',
    require => Group['red5']
  }

  staging::extract { "red5-1.0.1.tar.gz":
    target  => '/usr/local/',
    creates => "/usr/local/red5-server-1.0",
    require => [Staging::File["red5-1.0.1.tar.gz"],User['red5']],
  }

  file { 'red5-permissions':
    path    => "/usr/local/red5-server-1.0",
    owner   => 'red5',
    group   => 'red5',
    recurse => true,
    require => Staging::Extract["red5-1.0.1.tar.gz"]
  }

  file { "/usr/local/red5":
    ensure => link,
    target => '/usr/local/red5-server-1.0',
    require => File["/usr/local/red5-server-1.0"]
  }

  file { "/etc/init.d/red5":
    ensure => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
    content => template("red5/red5_init_script.erb")
  }

  firewall { '120 allow rtmp access':
    port   => 1935,
    proto  => tcp,
    action => accept,
  }

  package { 'java-1.8.0-openjdk':
    ensure => present
  }

  file { '/etc/sysconfig/red5': 
    ensure  => present,
    content => "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0"
  }
}
