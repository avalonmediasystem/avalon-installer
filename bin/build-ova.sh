#!/bin/bash

set -e
vagrant up
VM_UUID=$(cat .vagrant/machines/default/virtualbox/id)
HD_UUID=$(VBoxManage showvminfo --machinereadable $VM_UUID | grep ImageUUID | grep -o '[0-9a-fA-F-]\{36\}')
VM_DATE=$(date +%y%m%d)
VBoxManage snapshot "${VM_UUID}" take "avalon-vm-${VM_DATE}-bootstrapped"
vagrant ssh -c 'sudo /vagrant/bin/build-ova-guest.sh'
# VBoxManage controlvm $VM_UUID acpipowerbutton
until $(VBoxManage showvminfo --machinereadable $VM_UUID | grep -q ^VMState=.poweroff.)
do
  sleep 1
done
VBoxManage export "${VM_UUID}" --output "avalon-vm-${VM_DATE}.ova" --vsys 0 --product "Avalon Media System" --producturl "http://www.avalonmediasystem.org" --version "R2"
