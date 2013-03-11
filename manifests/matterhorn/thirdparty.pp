class matterhorn::thirdparty {
  include epel
  include nulrepo
  include mediainfo

  package { ["jam", "yasm", "scons", "zlib", "libjpeg-turbo", "libpng", "libtiff",
    "mp4v2", "SDL", "libogg", "libvorbis", "lame", "x264", "xvidcore", "libfaac", 
    "libtheora", "libvpx", "ffmpeg"]:
    ensure => present
  }
}
