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

class avalonrepo {
  yumrepo { 'avalon-public':
    name     => 'avalon_public',
    descr    => 'Avalon Media System RHEL repository',
    baseurl  => 'http://repo.avalonmediasystem.org/x86_64',
    cost     => '150',
    enabled  => '1',
    gpgcheck => '1',
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-avalon',
    require  => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-avalon'],

	}
  
  yumrepo { 'avalon-public-sources':
    name      => 'avalon_public_sources',
    descr     => 'Avalon Media System SRPMS repository',
    baseurl   => 'http://repo.avalonmediasystem.org/SRPMS',
    cost      => '100',
    enabled   => '1',
    gpgcheck  => '1',
    gpgkey    => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-avalon',
    require   => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-avalon'],
  }

	file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-avalon':
		ensure => present,
		owner  => 'root',
		group  => 'root',
		mode   => '0644',
		source => 'puppet:///local/RPM-GPG-KEY-avalon'
	}
}
