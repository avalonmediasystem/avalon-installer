class avalon::mysql {
  include mysql

  mysql::db { 'avalonweb':
    user     => 'avalonweb',
    password => 'SW5GI4aQLVmPLg',
    host     => 'localhost',
    grant    => ['all'],
    require  => Class['mysql::server']
  }
}