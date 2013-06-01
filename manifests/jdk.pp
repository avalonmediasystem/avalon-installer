class jdk (
  $package = 'java-1.6.0-openjdk'
) {
  package { $package: ensure => present }
}
