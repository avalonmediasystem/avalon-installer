class avalon::config(
  $ruby_version           = $avalon::params::ruby_version,
  $source_branch          = $avalon::params::source_branch,
  $deploy_tag             = $avalon::params::deploy_tag,
  $dropbox_user           = $avalon::params::dropbox_user,
  $dropbox_password_hash  = $avalon::params::dropbox_password_hash,
  $database_name          = $avalon::params::database_name,
  $database_user          = $avalon::params::database_user,
  $database_pass          = $avalon::params::database_pass,
  $database_host          = $avalon::params::database_host
) inherits avalon::params {
  notify { 'avalon config':
    message => "ruby_version: ${ruby_version}\nsource_branch: ${source_branch}\ndeploy_tag: ${deploy_tag}\ndropbox_user: ${dropbox_user}\ndropbox_password_hash: ${dropbox_password_hash}\ndatabase_name: ${database_name}\ndatabase_user: ${database_user}\ndatabase_pass: ${database_pass}\ndatabase_host: ${database_host}"
  }
}
