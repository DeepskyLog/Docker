#!/bin/bash
# Check if there is a network connection on the host machine.
SERVERIP=134.58.117.134

ping -c 3 $SERVERIP > /dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "Installing Scientific Linux updates"
  yum -y update
else
  echo "No network found, not installing Scientific Linux updates"
fi

service httpd24-httpd start

chown -R mysql /var/lib/mysql
mysql_install_db
chown -R mysql /var/lib/mysql
service mysql start
sleep 10s
RESULT=`mysqlshow deepskylog | grep -o deepskylog`
if [ "$RESULT" != "deepskylog" ]; then
  echo "CREATE database deepskylog;" | mysql
  mysql deepskylog < /www.deepskylog.org.sql
  rm /www.deepskylog.org.sql
fi

# Add an admin user
#mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'deepskylog'"
#mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"
