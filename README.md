# Avalon Media System Installer

## Vagrant Virtual Machine Install

1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) for your host machine
2. Download and install [Vagrant](http://downloads.vagrantup.com/) for your host machine
3. Download and extract the Avalon [install script](https://github.com/avalonmediasystem/avalon-vagrant/archive/flat.tar.gz)
4. In a terminal window, `cd` to the `avalon-vagrant-flat` directory you just extracted
5. Type `vagrant up`
6. Be patient. The script needs to download and launch a bare-bones Linux VM, then install and configure several dozen dependencies and servers. This could take 30 minutes or more even with a fast connection.
7. When the script finishes, open a web browser and attach to [http://localhost:10080/](http://localhost:10080/)

## Manual Puppet Install

1. Create and log into a CentOS 6.x or Red Hat Enterprise Linux 6.x system as a user with sudo rights

2. Become root

		sudo -s

3. Disable SELinux (which we're not currently set up to support)

		echo 0 > /selinux/enforce
		Edit `/etc/selinux/config` and change the value of `SELINUX` from `enforcing` to `permissive`

4. Install puppet from the Puppet Labs repository

		rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-6.noarch.rpm
		yum install puppet

5. Install git

		yum install git

6. Download and extract the Avalon [install script](https://github.com/avalonmediasystem/avalon-vagrant/archive/flat.tar.gz)

		wget https://github.com/avalonmediasystem/avalon-vagrant/archive/flat.tar.gz
		tar xzf flat.tar.gz

7. `cd avalon-vagrant-flat`

8. Set up the installation variables

		VAGRANT=`pwd`
		ln -s $VAGRANT/files /etc/puppet/avalon_files
		cd $VAGRANT/manifests

9. If the hostname clients should connect to is different from the default machine hostname, tell puppet about it

		export FACTER_avalon_public_address=avalon.example.edu

10. Execute the puppet script

		/usr/bin/ruby /usr/bin/puppet apply --fileserverconfig=$VAGRANT/fileserver.conf --modulepath=$VAGRANT/modules --hiera_config=$VAGRANT/heira/heira.yml --templatedir=$VAGRANT/templates ./avalon.pp --detailed-exitcodes

11. Be patient. The script needs to download and launch a bare-bones Linux VM, then install and configure several dozen dependencies and servers. This could take 30 minutes or more even with a fast connection.

12. When the script finishes, open a web browser and connect to the public address you configured above
