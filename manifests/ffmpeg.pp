#builds ffmpeg from a locally supplied ffmpeg srpm
class ffmpeg {
  include epel
  include nulrepo

  $ffmpeg_ver = '1.2-59a.el6'
  $specfile   = 'ffmpeg12.spec'

  $ffmpeg     = "ffmpeg-${ffmpeg_ver}.src.rpm"
  $ffmpeg_req = ['SDL-devel',
                 'a52dec-devel',
                 'bzip2-devel',
                 'faad2-devel',
                 'freetype-devel',
                 'frei0r-plugins-devel',
                 'gsm-devel',
                 'imlib2-devel',
                 'lame-devel',
                 'libdc1394-devel',
                 'libraw1394-devel',
                 'librtmp-devel',
                 'libtheora-devel',
                 'libva-devel',
                 'libfaac-devel',
                 'libvdpau-devel',
                 'libvorbis-devel',
                 'libvpx-devel',
                 'opencore-amr-devel',
                 'opencv-devel',
                 'openjpeg-devel',
                 'schroedinger-devel',
                 'speex-devel',
                 'texi2html',
                 'vo-aacenc-devel',
                 'x264-devel',
                 'xvidcore-devel',
                 'yasm',]
    
  $build_cmd  = "#!/bin/bash
cd /home/makerpm/
rpmdev-setuptree
rpm -i ffmpeg-${ffmpeg_ver}.src.rpm
rpmbuild -ba rpmbuild/SPECS/${specfile}\n"

#default path
Exec { path => ['/usr/bin', '/usr/sbin/', '/sbin/', '/bin',] }

  user { 'makerpm':
    ensure     => present,
    home       => '/home/makerpm',
    managehome => true,
    system     => true,
  }
  
  exec { 'install_ffmpeg_rpm':
    command => "rpm -i /home/makerpm/rpmbuild/RPMS/x86_64/ffmpeg-libs-${ffmpeg_ver}.x86_64.rpm && rpm -i /home/makerpm/rpmbuild/RPMS/x86_64/ffmpeg-${ffmpeg_ver}.x86_64.rpm",
    unless  => 'rpm -q ffmpeg',
    require => Exec["su -l makerpm -c '/home/makerpm/install_ffmpeg_src.sh'"],
  }

  package { 'rpmdevtools':
    ensure  => present,
    require => [User['makerpm'],Exec['yum Group Install']],
  }
  package { $ffmpeg_req:
    ensure  => installed,
    require => [Class['epel'],Class['nulrepo']]
  }

  exec { 'yum Group Install':
    unless  => '/usr/bin/yum grouplist "Development tools" | /bin/grep "^Installed Groups"',
    command => '/usr/bin/yum -y groupinstall "Development tools"',
  }

  file { '/home/makerpm/install_ffmpeg_src.sh':
    ensure  => present,
    mode    => 0755,
    owner   => 'makerpm',
    group   => 'makerpm',
    content => "$build_cmd",
    require => Package['rpmdevtools'],
  }
  
  exec { "su -l makerpm -c '/home/makerpm/install_ffmpeg_src.sh'":
    cwd     => '/home/makerpm',
    require => [File['/home/makerpm/install_ffmpeg_src.sh'],File["/home/makerpm/ffmpeg-${ffmpeg_ver}.src.rpm"]],
    creates => "/home/makerpm/rpmbuild/RPMS/x86_64/ffmpeg-${ffmpeg_ver}.x86_64.rpm",
    timeout => 3000,
  }
  
  file { "/home/makerpm/ffmpeg-${ffmpeg_ver}.src.rpm":
    source  => "puppet:///local/ffmpeg/ffmpeg-${ffmpeg_ver}.src.rpm",
    ensure  => file,
    mode    => 0755,
    owner   => makerpm,
    group   => makerpm,
    require => [File['/home/makerpm/install_ffmpeg_src.sh'],Package[$ffmpeg_req]],
  }



 
}
