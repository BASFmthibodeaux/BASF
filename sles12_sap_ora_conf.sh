CONF=etc
OLDSLES=mnt
LOG=set_configuration.log

#mount suse11 disk in the /mnt
mount /dev/$1/root /$OLDSLES/
mount /dev/$1/opt /$OLDSLES/opt/
mount /dev/$1/tmp /$OLDSLES/tmp/
mount /dev/$1/home /$OLDSLES/usr2/local/

#adding Autprized volumes to fstab
grep -i "xfs" /$OLDSLES/$CONF/fstab >> /$CONF/fstab

#transfer inportant files and configuration
rsync -avz  /$OLDSLES/usr/local/bin/  /usr/local/bin/
rsync -avz  /$OLDSLES/$CONF/ssh/ /$CONF/ssh/
rsync -avz  /$OLDSLES/$CONF/BASFfirewall.d/ /$CONF/BASFfirewall.d/
rsync -avz  /$OLDSLES/root/.ssh/ /root/.ssh/
cp -fr  /$OLDSLES/$CONF/sysctl.conf  /$CONF/sysctl.conf
cp -fr  /$OLDSLES/$CONF/resolv.conf  /$CONF/resolv.conf
cp -fr  /$OLDSLES/$CONF/passwd  /$CONF/passwd
cp -fr  /$OLDSLES/$CONF/shadow /$CONF/shadow
echo "root:sles11to12" |chpasswd 
cp -fr  /$OLDSLES/$CONF/services /$CONF/services
cp -fr  /$OLDSLES/$CONF/auto.master /$CONF/auto.master
rsync -avz  /$OLDSLES/root/scripts/ /root/scripts/
rsync -avz  /$OLDSLES/opt/special/ /opt/special/ && ln -s /opt/special/  /special/

#check if oracles DB is installed and running

if [ -f /$OLDSLES/etc/oratab ]
 then
   cp -fr  /$OLDSLES/$CONF/oratab /etc/oratab
   if  [ -f /$OLDSLES/$CONF/orainst.loc ]
  then
    cp -fr  /$OLDSLES/$CONF/orainst.loc /$CONF/orainst.loc
  else
    echo "there is not orainst.loc"
  fi
 else
   echo "There is not oracle DB installed"
fi

#setup network
for p in {0..1}
do 
if [ -f /etc/sysconfig/network/ifcfg-eth$p ]
 then 
   ls -la  /$OLDSLES/$CONF/sysconfig/network/ifcfg-eth$p
   rsync -avz  /$OLDSLES/$CONF/sysconfig/network/ /$CONF/sysconfig/network/ &&
   systemctl restart network
  else
    echo "names are difrent"
 fi
done 

#check 
diff /root/.ssh    /$OLDSLES/root/.ssh/  >> $LOG
diff /$CONF/ssh/   /$OLDSLES/$CONF/ssh/  >> $LOG     
diff /special       /$OLDSLES/special          
diff /$CONF/sysctl.conf    /$OLDSLES/$CONF/sysctl.conf  >> $LOG
diff /$CONF/resolv.conf    /$OLDSLES/$CONF/resolv.conf  >> $LOG
diff /$CONF/passwd         /$OLDSLES/$CONF/passwd       >> $LOG
diff /$CONF/shadow         /$OLDSLES/$CONF/shadow       >> $LOG
diff /$CONF/services       /$OLDSLES/$CONF/services     >> $LOG
diff /$CONF/auto.master    /$OLDSLES/$CONF/auto.master  >> $LOG

if [ -s $LOG ]
 then 
   cat $LOG
  else 
 reboot
fi 
 

