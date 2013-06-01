class avalon::shared {
  $auth_config = hiera('auth_config', '')
  $auth_yaml = $auth_config ? {
    /.+/ => inline_template('<%=YAML.dump(auth_config)%>'),
    /^$/ => template('avalon/shared/authentication.yml.erb')
  }

  file{ '/var/www/avalon/shared':
    source  => 'puppet:///modules/avalon/shared',
    owner   => 'avalon',
    group   => 'avalon',
    recurse => true
  }

  file{ '/var/www/avalon/shared/avalon.yml':
    ensure  => present,
    content => template('avalon/shared/avalon_yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    require => File['/var/www/avalon/shared']
  }

  file{ "/var/www/avalon/shared/authentication.yml":
    ensure  => present,
    content => $auth_yaml,
    owner   => 'avalon',
    group   => 'avalon',
    require => File['/var/www/avalon/shared']
  }

  file{ "/var/www/avalon/shared/database.yml":
    ensure  => present,
    content => template('avalon/shared/database.yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    require => File['/var/www/avalon/shared']
  }

  file{ "/var/www/avalon/shared/fedora.yml":
    ensure  => present,
    content => template('avalon/shared/fedora.yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    require => File['/var/www/avalon/shared']
  }

  file{ "/var/www/avalon/shared/matterhorn.yml":
    ensure  => present,
    content => template('avalon/shared/matterhorn.yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    require => File['/var/www/avalon/shared']
  }

  file{ "/var/www/avalon/shared/solr.yml":
    ensure  => present,
    content => template('avalon/shared/solr.yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    require => File['/var/www/avalon/shared']
  }

  file{ "/var/www/avalon/shared/role_map_${avalon::info::rails_env}.yml":
    ensure  => present,
    content => template('avalon/shared/role_map.yml.erb'),
    owner   => 'avalon',
    group   => 'avalon',
    require => File['/var/www/avalon/shared']
  }

  file{ ['/var/www/avalon/shared/log', '/var/www/avalon/shared/pids']:
    ensure  => 'directory',
    owner   => 'avalon',
    group   => 'avalon',
  }
}