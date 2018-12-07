#!/bin/bash
#created by Georgi Dimitrov

echo "$1 is a old vg name"
echo "$2 is a new vg name"

vgrename $1 $2

cp /etc/fstab /etc/fstab.back
sed -i "s/$1/$2/" /etc/fstab

if [ -f /boot/grub/menu.lst ]

  then
    cp    /boot/grub/menu.lst  /boot/grub/menu.back
    sed -i "s/$1/$2/" /boot/grub/menu.lst
        elif [ -f /boot/grub2/grub.cfg ]
        then
          cp    /boot/grub2/grub.cfg  /boot/grub2/grub.back
          sed -i "s/$1/$2/" /boot/grub2/grub.cfg
fi
