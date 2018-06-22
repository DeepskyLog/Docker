FROM scientificlinux/sl:6
LABEL Wim De Meester <deepskywim@gmail.com>

# Update all packages
RUN yum install -y yum-plugin-ovl
RUN yum install -y wget
RUN yum -y update

# Update to Scientific Linux 6.6
RUN yum -y install yum-conf-sl6x
RUN yum -y upgrade

# Add extra repository
RUN yum -y install yum-conf-sl-other

# Add the Scientific Linux Software Collection
RUN rpm -Uhv http://ftp.scientificlinux.org/linux/scientific/6x/external_products/softwarecollections/yum-conf-softwarecollections-2.0-1.el6.noarch.rpm

# Add epel repository
RUN cd /tmp
RUN wget http://epel.mirror.nucleus.be/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh epel-release-6-8.noarch.rpm
RUN yum -y update
RUN yum -y clean all

# Install apache
RUN yum -y install httpd24 httpd24-mod_ssl
RUN scl enable httpd24 bash
RUN chkconfig httpd24-httpd on
RUN yum -y clean all

# Add remi repository
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN rpm -Uhv remi-release-6.rpm
RUN yum -y install yum-utils
RUN yum -y clean all
RUN yum-config-manager --enable remi

# Install mariadb 10.1
RUN wget -O /etc/yum.repos.d/MariaDB101.repo https://raw.githubusercontent.com/DeepskyLog/Docker/master/MariaDB101.repo
RUN yum clean all
RUN yum -y install mysql mysql-devel mysql-server compat-mysql51

# Install php 7.2
RUN yum -y clean all
RUN yum -y install php72 php72-php-mbstring php72-php-pdo php72-php-json php72-php-pear php72-php-gd php72-php-common php72-php-mysqlnd php72-php-process php72-php-opcache php72-php-cli php72-php-zip php72-php-fpm
RUN chkconfig php72-php-fpm on

# Start httpd
EXPOSE 80

COPY httpd.conf /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf
ADD startServices.sh /startServices.sh
RUN chmod 755 /*.sh
RUN touch /var/log/httpd24/access_log /var/log/httpd24/error_log

# Add a data volume for the mysql database
VOLUME /var/lib/mysql

# Start mysql
EXPOSE 3306
COPY www.deepskylog.org.sql /www.deepskylog.org.sql

RUN yum -y reinstall tzdata
CMD ["/startServices.sh"]
