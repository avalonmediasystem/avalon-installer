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

class matterhorn::install(
  $treeish = "1.4.x",
  $tarfile = "matterhorn-1.4.tar.gz"
) {
  include staging

  group { 'matterhorn':
    ensure    => present,
    system    => true
  }

  user { 'matterhorn':
    ensure    => present,
    gid       => 'matterhorn',
    system    => true,
    require   => Group['matterhorn']
  }

  staging::file { $tarfile:
    subdir    => 'matterhorn',
    source    => "https://codeload.github.com/avalonmediasystem/avalon-felix/tar.gz/$treeish"
  }

  file { '/usr/local/matterhorn':
    ensure    => directory,
    owner     => 'matterhorn',
    group     => 'matterhorn',
    mode      => '0775'
  }
  
  exec { 'extract-matterhorn':
    command   => "/bin/tar xzf ${staging::path}/matterhorn/${tarfile} --strip-components 1",
    cwd       => "/usr/local/matterhorn",
    creates   => "/usr/local/matterhorn/lib",
    user      => "matterhorn",
    group     => "matterhorn",
    require   => [File['/usr/local/matterhorn'],User['matterhorn'],Staging::File[$tarfile]]
  }

}
