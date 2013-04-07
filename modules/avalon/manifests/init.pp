class avalon {
  include apache
  include avalon::packages
  include avalon::web
  include avalon::framework
  include avalon::security
  include avalon::mysql
}
