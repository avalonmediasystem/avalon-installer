#!/bin/bash

cd /root
echo "Installing firstboot and distribution tools..."
yum install -y NetworkManager-gnome firstboot perl-XML-Twig perl-YAML-LibYAML
rpm -i "http://www.avalonmediasystem.org/downloads/avalon-vm-2.2-5.noarch.rpm"
echo "Removing installation cruft..."
for f in `mount | grep vboxsf | cut -d ' ' -f 1`
do
  umount $f
  rm -rf $f
done
rm -rf /root/Downloads/* /var/avalon/dropbox/* /opt/staging /root/avalon-installer-flat /root/flat.tar.gz
echo "Removing guest additions"
/opt/VBoxGuestAdditions-4.3.10/uninstall.sh
yum clean all
echo "Resetting network configuration"
echo -n '' > /etc/udev/rules.d/70-persistent-net.rules
rm -f /tmp/foo
echo "Deleting vagrant user..."
/usr/sbin/userdel -rf vagrant
echo "Prepping firstboot..."
/usr/share/avalon-vm/dist-prep
echo "Clearing command history..."
history -cw
echo "Shutting down."
shutdown -h now
echo "Done."
