#!/bin/bash
#created by Georgi Dimitrov

#echo "$1 is a old vg name"
#echo "$2 is a new vg name"
read old_vg
read new_vg
echo $old_vg
echo $new_vg

vgrename $old_gv $new_vg

cp /etc/fstab /etc/fstab.back
sed -i "s/$old_vg/$new_vg/" /etc/fstab

if [ -f /boot/grub/menu.lst ]

  then
    cp    /boot/grub/menu.lst  /boot/grub/menu.back
    sed -i "s/$old_gv/$new_vg/" /boot/grub/menu.lst
        elif [ -f /boot/grub2/grub.cfg ]
        then
          cp    /boot/grub2/grub.cfg  /boot/grub2/grub.back
          sed -i "s/$old_vg/$new_vg/" /boot/grub2/grub.cfg
fi
