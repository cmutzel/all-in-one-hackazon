#!/bin/bash

#mysql has to be started this way as it doesn't work to call from /etc/init.d
#and files need to be touched to overcome overlay file system issues on Mac and Windows
find /var/lib/mysql -type f -exec touch {} \; && /usr/bin/mysqld_safe & 
sleep 10s
# Here we generate random passwords
MYSQL_USER="root"
MYSQL_PASSWORD=`date +%s|sha256sum|base64|head -c 10`
HACKAZON_DB="hackazon"
HACKAZON_USER="hackazon"
HACKAZON_PASSWORD=`date +%s|sha256sum|base64|head -c 10`
HASHED_PASSWORD=`php /passwordHash.php $HACKAZON_PASSWORD`

#This is so the passwords show up in logs. 
echo hackazon password: $HACKAZON_PASSWORD
echo $MYSQL_PASSWORD > /mysql-root-pw.txt
echo $HACKAZON_PASSWORD > /hackazon-db-pw.txt

#set DB password in db.php
sed -i "s/yourdbpass/$HACKAZON_PASSWORD/" /var/www/hackazon/assets/config/db.php
sed -i "s/youradminpass/$HACKAZON_PASSWORD/" /var/www/hackazon/assets/config/parameters.php

mysqladmin -u root password $MYSQL_PASSWORD
mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE $HACKAZON_DB; GRANT ALL PRIVILEGES ON $HACKAZON_DB.* TO '$HACKAZON_USER'@'localhost' IDENTIFIED BY '$HACKAZON_PASSWORD'; FLUSH PRIVILEGES;"
mysql -uroot -p$MYSQL_PASSWORD $HACKAZON_DB < "/var/www/hackazon/database/createdb.sql"
mysql -uroot -p$MYSQL_PASSWORD -e "UPDATE $HACKAZON_DB.tbl_users SET password='${HASHED_PASSWORD}' WHERE username='admin';"

killall mysqld
sleep 10s

supervisord -n
