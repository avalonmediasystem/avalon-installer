# script to run remotely on beryllium
# quit if error
set -e 

repo=avalon-installer
if [ ! -d "$repo" ]; then
  git clone -b iu-nightly https://github.com/phuongdh/$repo
  cd $repo
else
  cd $repo
  git checkout iu-nightly
  git pull
fi

git submodule init
git submodule update

vagrant destroy -f default
VM_DATE=$(date +%y%m%d)
output=avalon-vm-${VM_DATE}.ova
rm -f $output

./bin/build-ova.sh

scp $output pdinh@sycamore.dlib.indiana.edu:/srv/php/vov-prod-8803/htdocs/downloads/
