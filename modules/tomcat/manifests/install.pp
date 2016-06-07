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

class tomcat::install(
	$user       = $tomcat::params::user,
	$group      = $tomcat::params::group,
	$admin_user = $tomcat::params::admin_user,
	$admin_pass = $tomcat::params::admin_pass,
	$http_port  = $tomcat::params::http_port
) inherits tomcat::params {
  if defined(jdk) {
    include jdk
  }

  package { 'tomcat':
    name    => 'tomcat-7.0.32',
    ensure  => present,
    require => Class['avalonrepo'],
  }

  file { ['/usr/local/tomcat/conf/Catalina','/usr/local/tomcat/conf/Catalina/localhost']:
  	ensure  => directory,
  	owner   => $user,
  	group   => $group,
  	mode    => '0755',
  	require => Package['tomcat']
	}

	file { '/usr/local/tomcat/conf/server.xml':
		ensure  => present,
		content => template('tomcat/server.xml.erb'),
		owner   => $user,
		group   => $group,
  	require => Package['tomcat']
	}

	file { '/usr/local/tomcat/conf/tomcat-users.xml':
		ensure  => present,
		content => template('tomcat/tomcat-users.xml.erb'),
		owner   => $user,
		group   => $group,
  	require => Package['tomcat']
	}

}
