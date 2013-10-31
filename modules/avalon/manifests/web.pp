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

class avalon::web(
  $ruby_version  = "ruby-1.9.3-p429",
  $source_branch = "master",
  $deploy_tag = "bare-deploy"
) {
  include apache
  include solr
  include rvm
  include red5
  include staging
  include firewall
  include avalon::mysql

  File {
    selinux_ignore_defaults => true
  }

  exec { '/usr/local/rvm/scripts/rvm':
    subscribe  => Class['rvm::system']
  }

  group { 'rvm': 
    ensure     => present,
    system     => true
  }

  group { 'avalon':
    ensure     => present,
    system     => true,
  }

  user { 'avalon':
    ensure     => present,
    gid        => 'avalon',
    groups     => 'dropbox',
    managehome => true,
    system     => true,
    require    => [Group['avalon'], Group['dropbox']]
  }

  exec { "/usr/sbin/usermod -a -G avalon red5":
    unless  => "/bin/cat /etc/group | grep ^avalon | grep red5",
    require => [User['red5'], Group['avalon']];
  }

  exec { "/usr/sbin/usermod -a -G avalon matterhorn":
    unless  => "/bin/cat /etc/group | grep ^avalon | grep matterhorn",
    require => [User['matterhorn'], Group['avalon']];
  }

  ssh_authorized_key { 'vagrant_key_shared_with_avalon':
    ensure => present,
    user   => 'avalon',
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==',
    type   => 'ssh-rsa',
  }

  ssh_authorized_key { 'avalon_key_for_capistrano_deploy':
    ensure => present,
    user   => 'avalon',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC5u3clpfgbu1gwMDSXvUc6+cqsDNBwUMNwNGklJjVsFMbX36y9izY2/tK4mNBxJNW1Tek1O/nwkrbIoxaIzPLQS+nyf/Sz05wY3cUfSIptJazI82pu4lNtUK51RruRjsw49yzoUfMwHSetPqC+TgipNHo4QdizzVe9l0koznNeDtNm+JmlvdV78Dwrc6VFfaVwAOvXw2MMxvma1Ow58W648c/H9EDnr9YvILon1t3mqcEXlhPaRmbZe4IyYaeCRitIbKa+Twxw2VVSDAi7U2YhXYDUC2yIH2lcL+kSmHG+CYfuxsK9PmU1yHNzcWr9obXqXTSzi389k7EK60np7kDN',
    type   => 'ssh-rsa'
  }
  
  file { ['/var/www', '/var/www/avalon']:
    ensure  => 'directory',
    owner   => 'avalon',
    group   => 'avalon',
    mode    => 755,
  }

  file{ '/var/www/avalon/shared':
    source  => 'puppet:///modules/avalon/shared',
    owner   => 'avalon',
    group   => 'avalon',
    recurse => true,
    replace => false
  }

  file{ '/var/www/avalon/shared/avalon.yml':
    ensure  => present,
    content => template('avalon/shared/avalon_yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    replace => false,
    require => File['/var/www/avalon/shared']
  }

  file{ "/var/www/avalon/shared/authentication.yml":
    ensure  => present,
    content => template('avalon/shared/authentication.yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    replace => false,
    require => File['/var/www/avalon/shared']
  }

  file{ "/var/www/avalon/shared/database.yml":
    ensure  => present,
    content => template('avalon/shared/database.yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    replace => false,
    require => File['/var/www/avalon/shared']
  }

  file{ "/var/www/avalon/shared/fedora.yml":
    ensure  => present,
    content => template('avalon/shared/fedora.yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    replace => false,
    require => File['/var/www/avalon/shared']
  }

  file{ "/var/www/avalon/shared/matterhorn.yml":
    ensure  => present,
    content => template('avalon/shared/matterhorn.yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    replace => false,
    require => File['/var/www/avalon/shared']
  }

  file{ "/var/www/avalon/shared/solr.yml":
    ensure  => present,
    content => template('avalon/shared/solr.yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    replace => false,
    require => File['/var/www/avalon/shared']
  }

  file{ "/var/www/avalon/shared/role_map_${rails_env}.yml":
    ensure  => present,
    content => template('avalon/shared/role_map.yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    replace => false,
    require => File['/var/www/avalon/shared']
  }

  file{ ['/var/www/avalon/shared/log', '/var/www/avalon/shared/pids']:
    ensure  => 'directory',
    owner   => 'avalon',
    group   => 'avalon',
  }

  rvm::system_user { 'avalon': 
    require => [User['avalon'],Group['rvm']]
  }

  file{ ['/usr/local/rvm','/usr/local/rvm/user']:
    ensure  => directory
  }->file{ '/usr/local/rvm/user/db':
    ensure  => present,
    content => 'rubygems_version=2.1.5'
  }->rvm_system_ruby {
    $ruby_version:
      ensure      => 'present',
      default_use => true,
      build_opts  => '--movable',
      require     => Class['avalon::packages']
  }

  rvm_gemset {
    ["${ruby_version}@avalon","${ruby_version}@global"]:
      ensure  => present,
      require => Rvm_system_ruby[$ruby_version],
  }

  rvm_gem {
    "${ruby_version}@global/bundler":
      require => Rvm_gemset["${ruby_version}@global"],
  }

  class { 'rvm::passenger::apache':
    version => '3.0.19',
    ruby_version => $ruby_version,
    mininstances => '3',
    maxinstancesperapp => '0',
    maxpoolsize => '30',
    spawnmethod => 'smart-lv2';
  }

  apache::vhost { 'avalon':
    priority        => '10',
    servername      => $avalon_public_address,
    port            => '80',
    docroot         => '/var/www/avalon/current/',
    passenger       => true,
    notify          => Service['httpd'],
    # rvm has a dependency for mod_ssl
    ssl             => false,
    # this require is centos-specific, and kludgy!
    require         => File['/etc/httpd/conf.d/passenger.conf'],
  }

  staging::file { "avalon-${deploy_tag}.tar.gz":
    source  => "https://codeload.github.com/avalonmediasystem/avalon/tar.gz/${deploy_tag}",
    subdir  => avalon,
  }

  staging::extract { "avalon-${deploy_tag}.tar.gz":
    target  => "${staging::path}/avalon",
    subdir  => avalon,
    require => Staging::File["avalon-${deploy_tag}.tar.gz"]
  }

  file { "${staging::path}/avalon/deployment_key":
    ensure      => present,
    source      => "puppet:///modules/avalon/deployment_key",
    owner       => root,
    mode        => 0600
  }

  exec { "deploy-setup":
    command => "/usr/local/rvm/bin/rvm ${ruby_version} do bundle install",
    onlyif  => "/usr/bin/test ! -e /var/www/avalon/${deploy_tag}",
    cwd     => "${staging::path}/avalon/avalon-${deploy_tag}",
    require => [
      Staging::Extract["avalon-${deploy_tag}.tar.gz"],
      Apache::Vhost['avalon'],
      Rvm_gem["${ruby_version}@global/bundler"],
      Rvm_gem['passenger'],
      File["${staging::path}/avalon/deployment_key"]
    ]
  }

  exec { "deploy-application":
    command     => "/usr/local/rvm/bin/rvm ${ruby_version} do bundle exec cap puppet deploy >> ${staging::path}/avalon/deploy.log 2>&1",
    environment => ["HOME=/root", "RAILS_ENV=${rails_env}", "AVALON_BRANCH=${source_branch}"],
    creates     => "/var/www/avalon/${deploy_tag}",
    cwd         => "${staging::path}/avalon/avalon-${deploy_tag}",
    timeout     => 2400, # It shouldn't take 45 minutes, but Rubygems can be a bear
    require     => [Exec['deploy-setup'],Exec['reload-avalon-core']],
    notify      => Service['avalon_delayed_job']
  }->
  file { "/var/www/avalon/${deploy_tag}":
    ensure      => present,
    content     => $deploy_tag
  }

  file { '/var/www/avalon/current/.rvmrc':
    ensure      => absent,
    require     => Exec['deploy-application']
  }

  file { '/var/www/avalon/current/.ruby-version':
    ensure      => present,
    content     => "$ruby_version\n",
    require     => Exec['deploy-application']
  }

  file { '/var/www/avalon/current/public/streams':
    ensure      => link,
    target      => '/var/avalon/hls_streams',
    require     => Exec['deploy-application']
  }

  file { '/var/www/avalon/current/public/streams/.htaccess':
    source      => 'puppet:///modules/avalon/streams_htaccess',
    ensure      => present,
    mode        => 0755,
    owner       => 'avalon',
    group       => 'avalon',
    require     => [File['/var/www/avalon/current/public/streams'], File['/usr/local/sbin/avalon_auth']]
  }

  file { '/etc/init.d/avalon_delayed_job':
    content     => template('avalon/avalon_delayed_job_init_script.erb'),
    ensure      => present,
    mode        => 0755,
    require     => Exec['deploy-application']
  }

  service { 'avalon_delayed_job':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    subscribe  => File['/etc/init.d/avalon_delayed_job']
  }

  firewall { '100 allow http and https access':
    port   => [80, 443],
    proto  => tcp,
    action => accept,
  }
}
