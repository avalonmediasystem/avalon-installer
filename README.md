# Avalon Media System Installer

## Vagrant Virtual Machine Install

This method will create a [VirtualBox](https://www.virtualbox.org/) virtual machine, and then install a complete (though small) Avalon Media System instance inside of it. It uses [Vagrant](http://www.vagrantup.com/) and [Puppet](https://github.com/puppetlabs/puppet) to automate the entire process, end to end.

1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (v4.2.8 or higher) for your host machine
2. Download and install [Vagrant](http://downloads.vagrantup.com/) (v1.1.5 or higher) for your host machine
3. Download and extract the Avalon [install script](https://github.com/avalonmediasystem/avalon-vagrant/archive/flat.tar.gz)
4. In a terminal window, `cd` to the `avalon-vagrant-flat` directory you just extracted
5. Type `vagrant up`
6. Be patient. The script needs to download and launch a bare-bones Linux VM, then download, install and configure a whole lot of dependencies and servers. This could take 30 minutes or more even with a fast connection.
7. When the script finishes, open a web browser and attach to [http://localhost:10080/](http://localhost:10080/)

<span style="color:red">
**NOTE:** The installer needs to download dozens of system packages, software distributions, source files, and other information, largely from trusted third party repositories. Sometimes, one or more repositories might be offline, unresponsive, or otherwise unavailable, causing the Puppet provisioning software to display a series of errors about failed dependencies. *Don't Panic.* Fortunately, Puppet can usually figure out how to make things right. Simply type `vagrant provision` to try to repair the install. If it doesn't seem to work, you can always `vagrant destroy` and `vagrant up` again to start over.
</span>

### Controlling the Virtual Machine

 In order to...                                          | Type...
---------------------------------------------------------|-------------------
 ...put the Avalon VM into "sleep state"                 | `vagrant suspend`
 ...resume a suspended VM                                | `vagrant resume`
 ...shut down the Avalon VM, but keep it around          | `vagrant halt`
 ...terminate the VM and delete it from the host machine | `vagrant destroy`
 ...restart a halted VM, or recreate a destroyed one     | `vagrant up`

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

        wget https://github.com/avalonmediasystem/avalon-vagrant/archive/flat.tar.gz -O flat.tar.gz
        tar xzf flat.tar.gz

7. `cd avalon-vagrant-flat`

8. Set up the installation variables

        VAGRANT=`pwd`
        ln -s $VAGRANT/files /etc/puppet/avalon_files
        cd $VAGRANT/manifests

9. If the hostname clients should connect to is different from the default machine hostname, tell puppet about it

        export FACTER_avalon_public_address=avalon.example.edu

10. Execute the puppet script

        puppet apply --fileserverconfig=$VAGRANT/fileserver.conf --modulepath=$VAGRANT/modules --hiera_config=$VAGRANT/heira/heira.yml --templatedir=$VAGRANT/templates ./init.pp --detailed-exitcodes

11. Be patient. The manifest needs to download, install and configure a whole lot of dependencies and servers. This could take 30 minutes or more even with a fast connection.

12. When the script finishes, open a web browser and connect to the public address you configured above (e.g., `http://avalon.example.edu/`)

<span style="color:red">
**NOTE:** Puppet needs to download dozens of system packages, software distributions, source files, and other information, largely from trusted third party repositories. Sometimes, one or more repositories might be offline, unresponsive, or otherwise unavailable, causing Puppet to display a series of errors about failed dependencies. Fortunately, Puppet can usually figure out how to make things right. Simply repeat the `puppet apply ...` command in step 10 to try to repair the install.
</span>

## Ports

The Avalon Media System requires several ports to be open to client browsers. The Vagrant install handles all the port forwarding for local access automatically, but the manual install will require attention to make sure the required ports are open and accessible.

  Port     | Purpose              | External? | Vagrant Mapping 
 ----------|----------------------|-----------|-----------------
  80       | HTTP (Avalon)        | Yes       | 10080           
  1935     | RTMP (red5)          | Yes       | 11935           
  5080     | HTTP (red5)          | No        | -               
  8983     | HTTP (Fedora/Solr)   | No        | -               
  18080    | HTTP (Matterhorn)    | Yes       | 18080           
