class avalon::web {
  include apache
  include rvm

  rvm::system_user { vagrant: ; }

  rvm_system_ruby {
    'ruby-1.9.3-p392':
      ensure      => 'present',
      default_use => true,
      require     => Package['libyaml-devel'],
  }

  rvm_gemset {
    'ruby-1.9.3-p392@avalon':
      ensure  => present,
      require => Rvm_system_ruby['ruby-1.9.3-p392'],
  }
  rvm_gem {
    'ruby-1.9.3-p392@avalon/bundler':
      ensure  => '1.2.3',
      require => Rvm_gemset['ruby-1.9.3-p392@avalon'],
  }
  class { 'rvm::passenger::apache':
    version => '3.0.19',
    ruby_version => 'ruby-1.9.3-p392',
    mininstances => '3',
    maxinstancesperapp => '0',
    maxpoolsize => '30',
    spawnmethod => 'smart-lv2';
  }
}

