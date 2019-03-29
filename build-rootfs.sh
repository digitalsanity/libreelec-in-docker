#!/bin/bash

. config

archivename="${url##*/}"
ext='gz'
filename=`basename ${archivename} .$ext`

if [ -e "${archivename}" ]
then
  echo "Already have the image file: $archivename"
else
  if [ -e "${filename}" ]
  then
    echo "$filename exists.  Not downloading $url."
  else
    echo "Retrieving $url .."
    wget -q --show-progress --progress=bar:force:noscroll $url
  fi
fi

if [ -e "${filename}" ]
then
  echo "Already extracted to: $filename"
else
  echo "Extracting $filename .."
  if [ $ext == "gz" ]; then
    gzip -d "${archivename}"
  elif [ $ext == "xz" ]; then
    xz -d "${archivename}"
  fi
fi

declare -i start_sector
start_sector=$(/sbin/fdisk -l ./${filename} | awk -F" "  '{ print $3 }' | tail -n1)
(( start_offset = $start_sector * 512 ))

mkdir -p img-mount
(sudo umount img-mount || /bin/true)

if ! (sudo mount -o loop,offset=$start_offset ./${filename} ./img-mount); then    
    echo "mount failed, trying a different partition"
    mkdir -p sys-mount
    start_sector=$(/sbin/fdisk -l ./${filename} | awk -F" "  '{ print $3 }' | tail -n2 | head -n1)
    (( start_offset = $start_sector * 512 ))
    if ! (sudo mount -o loop,offset=$start_offset ./${filename} ./sys-mount); then
       echo "unable to mount.  error."
       exit
    else
      if ! (sudo mount -o loop ./sys-mount/SYSTEM ./img-mount); then
        echo "unable to find an image within the image."
        exit
      else
        echo "SYSTEM mounted"
        ls img-mount
      fi
    fi
fi

mkdir -p docker/rootfs
sudo rsync -axHAX --info=progress2 img-mount/ docker/rootfs/

sudo umount ./img-mount
rmdir ./img-mount

sudo umount ./sys-mount
rmdir ./sys-mount

echo $name >.release

echo "$url extracted to docker/rootfs/"

# cleanup
#rm "${filename}"
#rm "${archivename}"
# sudo mount -o loop,offset=16777216 ./LibreELEC-RK3399.arm-9.1-nightly-20190324-5ccaa74-rockpro64.img ./img-mount
