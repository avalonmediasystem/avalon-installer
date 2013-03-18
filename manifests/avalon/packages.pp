class avalon::packages {
  package { 'mediainfo': 
    ensure => installed,
    require => Class['nulrepo'],
  }
  
}
