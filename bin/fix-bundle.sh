#!/bin/bash

rvm_path=/usr/local/rvm 
wget https://raw.githubusercontent.com/avalonmediasystem/avalon/${1}/Gemfile 
wget https://raw.githubusercontent.com/avalonmediasystem/avalon/${1}/Gemfile.lock 
ln -s /var/www/avalon/shared/Gemfile.local .
/usr/local/rvm/bin/rvm-shell 'default' -c 'bundle install --path /var/www/avalon/shared/bundle --path=/var/www/avalon/shared/gems --without development test'
rm Gemfile Gemfile.lock Gemfile.local
