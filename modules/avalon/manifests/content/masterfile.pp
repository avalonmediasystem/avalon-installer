class avalon::content::masterfile(
  $export = false,
  $mount  = false
) {
  include avalon::content

  file { "${avalon::info::root_dir}/masterfiles": 
    ensure  => directory,
    group   => 'avalon',
    mode    => 0775,
    require => [File[$avalon::info::root_dir]]
  }

  if $mount {
    mount { "${avalon::info::root_dir}/masterfiles":
      device  => "$mount:/${avalon::info::root_dir}/masterfiles",
      fstype  => "nfs",
      ensure  => "mounted",
      options => "defaults",
      atboot  => "true",
      require => File["${avalon::info::root_dir}/masterfiles"]
    }
  } else {
    if $export {
      include avalon::ports::export
      concat::fragment { 'export-masterfiles':
        content => "${avalon::info::root_dir}/masterfiles ${export}(rw,async)\n",
        target  => '/etc/exports'
      }
    }
  }
}