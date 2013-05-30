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

  if $avalon::info::dropbox_password_hash =~ /^$/  {
    fail("Missing info: avalon::info::dropbox_password")
  }
  
  group { 'dropbox':
    ensure => present,
    system => true
  }

  user { $avalon::info::dropbox_user:
    ensure   => present,
    system   => true,
    gid      => 'dropbox',
    home     => '/dropbox', # because it's already chrooted to $avalon::info::root_dir
    password => $avalon::info::dropbox_password_hash,
    require  => Group['dropbox']
  }

  file { $avalon::info::root_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => 0755
  }

  file { "${avalon::info::root_dir}/dropbox":
    ensure  => directory,
    owner   => $avalon::info::dropbox_user,
    group   => 'dropbox',
    mode    => 2775,
    require => [File[$avalon::info::root_dir],User[$avalon::info::dropbox_user]]
  }

  file { ["${avalon::info::root_dir}/masterfiles","${avalon::info::root_dir}/hls_streams"]:
  	ensure  => directory,
  	owner   => 'avalon',
  	group   => 'avalon',
  	mode    => 0775,
    require => [File[$avalon::info::root_dir],User['avalon']]
	}

  augeas { "sshd_config":
    context => "/files/etc/ssh/sshd_config",
    changes => [
      "set Subsystem/sftp 'internal-sftp'",
      "set Match[Condition/User='${avalon::info::dropbox_user}']/Condition/User '${avalon::info::dropbox_user}'",
      "set Match[Condition/User='${avalon::info::dropbox_user}']/Settings/ChrootDirectory '${avalon::info::root_dir}'",
      "set Match[Condition/User='${avalon::info::dropbox_user}']/Settings/AllowTcpForwarding 'no'",
      "set Match[Condition/User='${avalon::info::dropbox_user}']/Settings/ForceCommand 'internal-sftp'"
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
}
