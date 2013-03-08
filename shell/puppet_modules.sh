#!/bin/bash

cd /etc/puppet/modules
for m in alup-rbenv nanliu-staging ripienaar-concat; do
	modname=${m##*-}
	if [ ! -d ./$modname ]; then
		echo "Installing $m from Puppetforge"
		puppet module install $m
	fi
done
