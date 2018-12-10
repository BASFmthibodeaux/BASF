CONF=etc
OLDSLES=mnt
LOG=set_configuration.log

#mount suse11 disk in the /mnt
mount /dev/$1/root /$OLDSLES/
mount /dev/$1/opt /$OLDSLES/opt/
mount /dev/$1/tmp /$OLDSLES/tmp/
mount /dev/$1/home /$OLDSLES/usr2/local/



#transfer inportant files and configuration
cp -fr  /$OLDSLES/usr/local/bin/  /usr/local/bin/
cp -fr  /$OLDSLES/$CONF/ssh/ /$CONF/ssh/
rsync -avz  /$OLDSLES/$CONF/BASFfirewall.d/ /$CONF/BASFfirewall.d/
cp -fr  /$OLDSLES/root/.ssh/ /root/.ssh/
cp -fr  /$OLDSLES/$CONF/sysctl.conf  /$CONF/sysctl.conf
cp -fr  /$OLDSLES/$CONF/resolv.conf  /$CONF/resolv.conf
cp -fr  /$OLDSLES/$CONF/passwd  /$CONF/passwd
cp -fr  /$OLDSLES/$CONF/shadow /$CONF/shadow
echo "root:sles11to12" |chpasswd 
cp -fr  /$OLDSLES/$CONF/services /$CONF/services
cp -fr  /$OLDSLES/$CONF/auto.master /$CONF/auto.master
cp -fr  /$OLDSLES/root/scripts/ /root/scripts/
cp -fr  /$OLDSLES/opt/special/ /opt/special/ && ln -s /opt/special/  /special/

#check if oracles DB is installed and running

if [ -f /$OLDSLES/etc/oratab ]
 then
   cp -fr  /$OLDSLES/etc/oratab /etc/oratab
   if  [ -f /$OLDSLES/etc/orainst.loc ]
  then
    cp -fr  /$OLDSLES/etc/orainst.loc /etc/orainst.loc
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
   ls -la  /$OLDSLES/etc/sysconfig/network/ifcfg-eth$p
   rsync -avz  /$OLDSLES/etc/sysconfig/network/ /etc/sysconfig/network/ &&
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
p=$(wc -l $LOG)
if [ $p -eq "0" ]
 then 
   reboot
  else 
 cat $LOG
fi 
 

