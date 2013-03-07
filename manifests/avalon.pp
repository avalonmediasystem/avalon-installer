class must-have {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }

  package { ["curl", "g++", "libsqlite3-dev", 
    "libv8-dev", "libxml2-dev", "libxslt1-dev", "make", "openjdk-6-jdk", "zip"]:
    ensure => present,
    require => Exec["apt-get update"]
  }
}

include must-have

rbenv::install { "vagrant":
  group => "vagrant",
  home  => "/home/vagrant",
  require => Exec["apt-get update"]
}

rbenv::compile { "1.9.3-p392":
  user => "vagrant",
  home => "/home/vagrant",
  global => true,
  require => Rbenv::Install["vagrant"]
}

class matterhorn-deps {
  package { ["jam", "yasm", "scons", "zlib1g", "libjpeg62", "libpng3", "libtiff4", 
    "libmp4v2-dev", "libsdl-dev", "libogg-dev", "libvorbis-dev", 
    "libmp3lame-dev", "libx264-dev", "libxvidcore-dev", "libfaac-dev", 
    "libtheora-dev", "libvpx-dev"]:
    ensure => present,
    require => Exec["apt-get update"]
  }
}

include matterhorn-deps