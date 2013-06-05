class avalon::content::stream(
  $export = $avalon::content::mountable::export,
  $mount  = $avalon::content::mountable::mount
) inherits avalon::content::mountable {
  include avalon::content
  notify { 'stream mounts':
    message => "mount: $mount; export: $export"
  }

  file { ["${avalon::info::root_dir}/rtmp_streams","${avalon::info::root_dir}/hls_streams"]: 
    ensure  => directory,
    group   => 'avalon',
    mode    => 0775,
    require => File[$avalon::info::root_dir]
  }

  if $mount {
    mount { "${avalon::info::root_dir}/rtmp_streams":
      device  => "$mount:/${avalon::info::root_dir}/rtmp_streams",
      require => File["${avalon::info::root_dir}/rtmp_streams"]
    }

    mount { "${avalon::info::root_dir}/hls_streams":
      device  => "$mount:/${avalon::info::root_dir}/hls_streams",
      require => File["${avalon::info::root_dir}/hls_streams"]
    }
  } else {
    if $export {
      include avalon::ports::export
      concat::fragment { 'export-streams':
        content => "${avalon::info::root_dir}/rtmp_streams ${export}(rw,async)\n${avalon::info::root_dir}/hls_streams ${export}(rw,async)]\n",
        target  => '/etc/exports'
      }
    }
  }
}