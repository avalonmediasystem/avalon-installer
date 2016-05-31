# Copyright 2011-2013, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
# 
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed 
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the 
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

#builds ffmpeg from a locally supplied ffmpeg srpm
class ffmpeg(
  $binary  = 'true',
  $version = '2.4.2-1.el7'
) {
  include epel
  include nulrepo

  $ffmpeg_ver = $version
  $specfile   = 'ffmpeg24.spec'

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
  
  if "$binary" in ['true','rpm'] {
    exec { 'build_ffmpeg_rpm':
      command => "su -l makerpm -c '/home/makerpm/install_ffmpeg_src.sh'",
      cwd     => '/home/makerpm',
      require => [File['/home/makerpm/install_ffmpeg_src.sh'],File["/home/makerpm/ffmpeg-${ffmpeg_ver}.src.rpm"]],
      creates => "/home/makerpm/rpmbuild/RPMS/x86_64/ffmpeg-${ffmpeg_ver}.x86_64.rpm",
      timeout => 3000,
    }
    
    if $binary == 'true' {
      exec { 'install_ffmpeg_rpm':
        command => "rpm -i /home/makerpm/rpmbuild/RPMS/x86_64/ffmpeg-libs-${ffmpeg_ver}.x86_64.rpm && rpm -i /home/makerpm/rpmbuild/RPMS/x86_64/ffmpeg-${ffmpeg_ver}.x86_64.rpm",
        unless  => 'rpm -q ffmpeg',
        require => Exec['build_ffmpeg_rpm'],
      }
    }
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
