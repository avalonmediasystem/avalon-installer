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

# Install and configure the Avalon application
class avalon::framework {
  include epel
  include rvm
  include stdlib
  include avalon::content::base
  
  if $avalon_dropbox_password_hash =~ /^$/  {
    fail("Missing fact: avalon_dropbox_password")
  }
  
  group { 'dropbox':
    ensure => present,
    system => true
  }

  augeas { "sshd_config":
    context => "/files/etc/ssh/sshd_config",
    changes => [
      "set Subsystem/sftp 'internal-sftp'",
      "set Match[Condition/User='$avalon_dropbox_user']/Condition/User '$avalon_dropbox_user'",
      "set Match[Condition/User='$avalon_dropbox_user']/Settings/ChrootDirectory '/var/avalon'",
      "set Match[Condition/User='$avalon_dropbox_user']/Settings/AllowTcpForwarding 'no'",
      "set Match[Condition/User='$avalon_dropbox_user']/Settings/ForceCommand 'internal-sftp'"
    ],
    notify => Service["sshd"],
  }

  service { "sshd":
    name => $operatingsystem ? {
      Debian => "ssh",
      default => "sshd",
    },
    require => Augeas["sshd_config"],
    enable => true,
    ensure => running,
  }

  file { "/usr/local/sbin/fedora_rebuild_db.sh":
    ensure  => present,
    source  => 'puppet:///modules/avalon/fedora_rebuild_db.sh',
    mode    => '0775',
    require => Package['expect']
  }
}
