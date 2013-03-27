class avalon::packages {
  include mediainfo
  
  package { ['cronie', 'curl', 'sqlite', 'mysql-devel', 'v8-devel', 'zip', 'libyaml-devel', 'libffi-devel']:
    ensure  => present,
    require => [Class['epel'],Class['nulrepo']],
  }
}
