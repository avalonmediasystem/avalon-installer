class avalon::content::base {

  group { ['avalon','dropbox']:
    ensure => present,
    system => true
  }

  file { $avalon::info::root_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => 0755
  }

}