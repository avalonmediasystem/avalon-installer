class avalon::content::mountable(
  $export = false,
  $mount  = false
) {
  include avalon::content::base
  
  Mount {
    fstype  => "nfs",
    ensure  => "mounted",
    options => "defaults",
    atboot  => "true",
  }
}