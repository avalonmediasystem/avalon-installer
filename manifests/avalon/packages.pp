class avalon::packages {
  include mediainfo
  
  package { ['curl', 'sqlite', 'v8-devel', 'zip', 'libyaml-devel', 'libffi-devel']:
    ensure  => present,
    require => [Class['epel'],Class['nulrepo']],
  }
}
