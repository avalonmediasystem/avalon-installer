class avalon::packages {

  package { ['curl', 'sqlite', 'v8-devel', 'zip', 'libyaml-devel','mediainfo',]:
    ensure  => present,
    require => [Class['epel'],Class['nulrepo']],
  }



}
