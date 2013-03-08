class epel {
  exec { "epel-release":
    command => "/bin/rpm -i http://fedora-epel.mirror.lstn.net/6/x86_64/epel-release-6-8.noarch.rpm",
    creates => "/etc/yum.repos.d/epel.repo"
  }
}

class nul-repo {
  file { '/etc/yum.repos.d/NUL.repo':
    source => "puppet:///local/NUL.repo"
  }

  file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-nul':
    source => "puppet:///local/RPM-GPG-KEY-nul",
    require => File['/etc/yum.repos.d/NUL.repo']
  }
}

class avalon {
  include epel
  include nul-repo

  package { ["curl", "gcc-c++", "libcurl-devel", "sqlite", "v8-devel", 
    "libxml2-devel", "libxslt-devel", "make", "mediainfo", "zip"]:
    ensure => present
  }

  file { "/home/vagrant/.bash_profile":
    source => "puppet:///local/bash_profile"
  }

  rbenv::install { "vagrant":
    group => "vagrant",
    home  => "/home/vagrant"
  }

  rbenv::compile { "1.9.3-p392":
    user => "vagrant",
    home => "/home/vagrant",
    global => true,
    require => Rbenv::Install["vagrant"]
  }
}

class jdk {
  include epel

  package { "java-1.7.0-openjdk":
    ensure => present,
    require => Exec['epel-release']
  }

  file { '/usr/java/default':
    ensure => link,
    target => "/usr/lib/jvm/jre-1.7.0-openjdk.x86_64",
    require => Package['java-1.7.0-openjdk']
  }
}

class db {
  include epel
  include nul-repo
  include jdk

  class { "fedora":
    fedora_base => "/usr/local/avalon",
    fedora_home => "/usr/local/avalon/fedora",
    tomcat_home => "/usr/local/avalon/tomcat",
    server_host => "localhost",
    user => "tomcat7",
    require => [Class['nul-repo']]
  }
}

class matterhorn::deps {
  include epel
  include nul-repo

  package { ["jam", "yasm", "scons", "zlib", "libjpeg", "libpng", "libtiff", 
    "mp4v2", "SDL", "libogg", "libvorbis", "lame", "x264", "xvidcore", "libfaac", 
    "libtheora", "libvpx", "ffmpeg", "mediainfo"]:
    ensure => present,
    require => [Exec['epel-release'],File['/etc/yum.repos.d/NUL.repo']]
  }
}

class matterhorn {
  include jdk
  include matterhorn::deps
}

include avalon
include db
include matterhorn
