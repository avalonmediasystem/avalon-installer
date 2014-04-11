#!/bin/bash

cd /root
echo "Installing firstboot and distribution tools..."
yum install -y NetworkManager-gnome firstboot perl-XML-Twig perl-YAML-LibYAML
rpm -i "http://www.avalonmediasystem.org/downloads/avalon-vm-2.1-1.noarch.rpm"
echo "Removing installation cruft..."
for f in `mount | grep vboxsf | cut -d ' ' -f 1`
do
  umount $f
  rm -rf $f
done
rm -rf /root/Downloads/* /var/avalon/dropbox/* /home/makerpm/rpmbuild /opt/staging /root/avalon-installer-flat /root/flat.tar.gz
yum clean all
echo "Zeroing empty disk space..."
swapoff /dev/mapper/VolGroup-lv_swap
dd if=/dev/zero of=/dev/mapper/VolGroup-lv_swap bs=1M
mkswap /dev/mapper/VolGroup-lv_swap
dd if=/dev/zero of=/tmp/foo bs=1M oflag=direct
rm /tmp/foo
echo "Deleting vagrant user..."
/usr/sbin/userdel -rf vagrant
echo "Prepping firstboot..."
/usr/share/avalon/dist-prep
echo "Clearing command history..."
history -cw
echo "Shutting down."
shutdown -h now
echo "Done."
