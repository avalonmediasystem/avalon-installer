#!/bin/bash

set -e
mv hiera/data/custom.yaml hiera/data/custom.yaml.orig
cp hiera/data/avalon-ova.yaml hiera/data/custom.yaml
vagrant up
VM_UUID=$(cat .vagrant/machines/default/virtualbox/id)
HD_UUID=$(VBoxManage showvminfo --machinereadable $VM_UUID | grep ImageUUID | grep -o '[0-9a-fA-F-]\{36\}')
VM_DATE=$(date +%y%m%d)
VBoxManage snapshot "${VM_UUID}" take "avalon-vm-${VM_DATE}-bootstrapped"
vagrant ssh -c 'cp /vagrant/bin/build-ova-guest.sh /tmp; sudo /tmp/build-ova-guest.sh'
# VBoxManage controlvm $VM_UUID acpipowerbutton

until $(VBoxManage showvminfo --machinereadable $VM_UUID | grep -q ^VMState=.poweroff.)
do
  sleep 1
done

for share in `VBoxManage showvminfo --machinereadable $VM_UUID | grep SharedFolderName | cut -d '=' -f 2 | tr -d '"'`
do
  VBoxManage sharedfolder remove "${VM_UUID}" --name $share  
done

for rule in `VBoxManage showvminfo --machinereadable $VM_UUID | grep Forwarding | tr -d '"' | cut -d '=' -f 2 | cut -d ',' -f 1`
do
  VBoxManage modifyvm "${VM_UUID}" --natpf1 delete "${rule}"
done

VBoxManage modifyvm "${VM_UUID}" --name "Avalon Media System 3.0"

VBoxManage guestproperty set "${VM_UUID}" /VirtualBox/GuestAdd/Vbgl/Video/SavedMode 1024x768x32

VBoxManage export "${VM_UUID}" --output "avalon-vm-${VM_DATE}.ova" --vsys 0 --product "Avalon Media System" --producturl "http://www.avalonmediasystem.org" --version "R3"
