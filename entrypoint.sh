#!/bin/sh
rm -f $0
passwd=Admin$RANDOM
if [ ! -z "$PASSWD" ];then
    passwd=$PASSWD
fi
echo "当前ROOT密码为$passwd"
echo "root:$passwd"|chpasswd

mysqld_safe --nowatch --datadir=/var/lib/mysql
sleep 5
mysqladmin -u root password "$passwd"
mysql -u root -p$passwd -e"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$passwd' WITH GRANT OPTION;"
mysql -u root -p$passwd -e"FLUSH PRIVILEGES;"

$@
/usr/sbin/sshd -D
