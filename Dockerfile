FROM ringo/scientific:6.8
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

# Add epel repository
RUN cd /tmp
RUN wget http://epel.mirror.nucleus.be//6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh epel-release-6-8.noarch.rpm
RUN yum -y update
RUN yum -y clean all

# Install apache
RUN yum -y install httpd
RUN yum -y clean all

# Add remi repository
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN rpm -Uhv remi-release-6.rpm
RUN yum -y install yum-utils
RUN yum -y clean all
RUN yum-config-manager --enable remi
RUN yum-config-manager --enable remi-php56

# Install mariadb 10.1
RUN wget -O /etc/yum.repos.d/MariaDB101.repo https://raw.githubusercontent.com/DeepskyLog/Docker/master/MariaDB101.repo
RUN yum clean all
RUN yum -y install mysql mysql-devel mysql-server compat-mysql51

# Install php 5.6
RUN yum -y clean all
RUN yum -y --enablerepo=remi,remi-php56 install php php-xml php-mbstring php-mcrypt php-cli php-gd php-pdo php-mysql

# Start httpd
EXPOSE 80

COPY httpd.conf /etc/httpd/conf/httpd.conf
ADD startServices.sh /startServices.sh
RUN chmod 755 /*.sh
RUN touch /var/log/httpd/access_log /var/log/httpd/error_log

# Add a data volume for the mysql database
VOLUME /var/lib/mysql

# Start mysql
EXPOSE 3306
COPY www.deepskylog.org.sql /www.deepskylog.org.sql

CMD ["/startServices.sh"]
