class avalon::content::base {

  file { $avalon::info::root_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => 0755
  }

}