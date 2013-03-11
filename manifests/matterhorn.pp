class matterhorn {
  include matterhorn::thirdparty

  staging::file { 'matterhorn.tar.gz':
    source  => 'https://github.com/avalonmediasystem/avalon-felix/archive/1.4.x.tar.gz',
    timeout => 1200,
    subdir  => 'matterhorn'
  }

  staging::extract { 'matterhorn.tar.gz':
    subdir => 'matterhorn',
    target  => '/usr/local',
    creates => '/usr/local/avalon-felix-1.4.x',
    require => [Staging::File['matterhorn.tar.gz']],
  }

  file { '/usr/local/matterhorn':
    ensure => link,
    target => '/usr/local/avalon-felix-1.4.x',
    require => [Staging::Extract['matterhorn.tar.gz'],Class['matterhorn::thirdparty']]
  }
}
