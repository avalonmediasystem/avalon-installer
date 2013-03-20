class nulrepo {
  #testing public repo
  #	yumrepo { 'NUL-private':
  #		name      => 'nul_private',
  #		descr     => 'NUL Library RHEL repository',
  #		baseurl   => 'http://yumrepo.library.northwestern.edu/6/x86_64',
  #		cost      => '100',
  #		enabled   => '1',
  #		gpgcheck  => '1',
  #		gpgkey    => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-nul',
  #    require   => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-nul'],
  #	}

  #  yumrepo { 'NUL-sources':
  #    name      => 'nul_sources',
  #    descr     => 'NUL Library RHEL SRPMS repository',
  #    baseurl   => 'http://yumrepo.library.northwestern.edu/6/SRPMS',
  #    cost      => '100',
  #    enabled   => '1',
  #    gpgcheck  => '1',
  #    gpgkey    => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-nul',
  #    require   => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-nul'],
  #  }
	
  yumrepo { 'NUL-public':
    name     => 'nul_public',
    descr    => 'NUL Library Public RHEL repository',
    baseurl  => 'http://yumrepo-public.library.northwestern.edu/x86_64',
    cost     => '150',
    enabled  => '1',
    gpgcheck => '1',
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-nul',
    require  => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-nul'],

	}
  
  yumrepo { 'NUL-public-sources':
    name      => 'nul_public_sources',
    descr     => 'NUL Library RHEL SRPMS repository',
    baseurl   => 'http://yumrepo-public.library.northwestern.edu/SRPMS',
    cost      => '100',
    enabled   => '1',
    gpgcheck  => '1',
    gpgkey    => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-nul',
    require   => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-nul'],
  }

	file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-nul':
		ensure => present,
		owner  => 'root',
		group  => 'root',
		mode   => '0644',
		source => 'puppet:///local/RPM-GPG-KEY-nul'
	}
}
