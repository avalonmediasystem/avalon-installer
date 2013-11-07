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

class avalon-dist::prep {

  package {"avalon-vm":
    ensure => present,
    provider => rpm,
    source => "http://www.avalonmediasystem.org/downloads/avalon-vm-2.0-1.noarch.rpm",
    require => Class['avalon-dist::web']
  }

  exec {'clean-filesystem':
    command => "rm -rf /root/Downloads/* /var/avalon/dropbox/* /home/makerpm/rpmbuild /opt/staging /root/avalon-installer-flat /root/flat.tar.gz",
    require => Package['avalon-vm'] #Make sure this is done after everything before dist-prep
  }

  exec {'clean-yum':
    command => "yum clean all",
    require => Package['avalon-vm'] #Make sure this is done after all packages have been loaded
  }

  exec {'swap-off':
    command => "iswapoff /dev/mapper/vg_avalon-lv_swap; dd if=/dev/zero of=/dev/mapper/vg_avalon-lv_swap bs=1M; mkswap /dev/mapper/vg_avalon-lv_swap",
    require => [Exec['clean-yum'], Exec['clean-filesystem']]
  }

  exec {'clean-disk':
    command => "dd if=/dev/zero of=/tmp/foo bs=1M oflag=direct; rm /tmp/foo",
    require => Exec['swap-off'] 
  }

  exec {'dist-prep':
    command => "/usr/share/avalon/dist-prep",
    require => [Package['avalon-vm'], Exec['clean-disk']]
  }

  exec {'clean-history':
    command => "history -cw",
    require => Exec['dist-prep'] #Do this at the end of everything!
  }
}
