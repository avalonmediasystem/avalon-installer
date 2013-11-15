#!/bin/bash

set -e
vagrant up
VM_UUID=`VBoxManage list runningvms | grep -o '[0-9a-fA-F]\{8\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{12\}'`
HD_UUID=`VBoxManage list -l runningvms | grep "SATA.*UUID" | grep -o '[0-9a-fA-F]\{8\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{12\}'`
VM_DATE=`date +%y%m%d`
VBoxManage snapshot "${VM_UUID}" take "avalon-vm-${VM_DATE}-bootstrapped"
vagrant ssh -c 'sudo /vagrant/bin/build-ova-guest.sh'
vagrant halt
# VBoxManage modifyhd "${HD_UUID}" --compact
VBoxManage export "${VM_UUID}" --output "avalon-vm-${VM_DATE}.ova" --product "Avalon Media System" --producturl "http://www.avalonmediasystem.org" --version "R2"
