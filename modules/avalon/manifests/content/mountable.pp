class avalon::content::mountable(
  $export = false,
  $mount  = false
) {
  Mount {
    fstype  => "nfs",
    ensure  => "mounted",
    options => "defaults",
    atboot  => "true",
  }
}