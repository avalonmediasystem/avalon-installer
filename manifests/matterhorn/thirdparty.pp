class matterhorn::thirdparty {
  include epel
  include nulrepo

  package { ["jam", "yasm", "scons", "zlib", "libjpeg", "libpng", "libtiff", 
    "mp4v2", "SDL", "libogg", "libvorbis", "lame", "x264", "xvidcore", "libfaac", 
    "libtheora", "libvpx", "ffmpeg", "mediainfo"]:
    ensure => present
  }
}
