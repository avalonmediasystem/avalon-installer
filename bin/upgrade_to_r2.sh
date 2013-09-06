#!/bin/bash

git clone http://github.com/avalonmediasystem/avalon-installer avalon-installer-r2
cd avalon-installer-r2
git checkout r2
git submodule update --init
ln -fs `pwd`/files /etc/puppet/avalon_files
tail -f /opt/staging/avalon/deploy.log &
puppet apply --fileserverconfig=fileserver.conf --modulepath=modules --hiera_config=hiera/hiera.yml --templatedir=templates manifests/init.pp --detailed-exitcodes
