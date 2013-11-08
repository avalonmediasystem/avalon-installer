class avalon::content::masterfile(
  $export = $avalon::content::mountable::export,
  $mount  = $avalon::content::mountable::mount
) inherits avalon::content::mountable {
  include avalon::content
  notify { 'masterfile mounts':
    message => "mount: $mount; export: $export"
  }

  file { "${avalon::info::root_dir}/masterfiles": 
    ensure  => directory,
    group   => 'avalon',
    mode    => 0775,
    require => [File[$avalon::info::root_dir]]
  }

  if $mount {
    mount { "${avalon::info::root_dir}/masterfiles":
      device  => $mount,
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