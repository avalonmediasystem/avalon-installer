class avalon::matterhorn {
  exec { "/usr/sbin/usermod -a -G avalon matterhorn":
    unless  => "/bin/cat /etc/group | grep ^avalon | grep matterhorn",
    require => [User['matterhorn'], Group['avalon']];
  }
}