#!/bin/sh

apt update -y &&
apt-get install -y autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php7.0 libgd2-xpm-dev &&
cd /tmp &&
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.3.4.tar.gz &&
tar xzf nagioscore.tar.gz &&
cd /tmp/nagioscore-nagios-4.3.4/ &&
./configure --with-httpd-conf=/etc/apache2/sites-enabled &&
make all &&
useradd nagios &&
usermod -a -G nagios www-data &&
make install &&
make install-init &&
update-rc.d nagios defaults &&
make install-commandmode &&
make install-config &&
make install-webconf &&
a2enmod rewrite &&
a2enmod cgi
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin &&
systemctl restart apache2.service &&
systemctl start nagios.service &&

#nagios plugins setup
apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext &&
cd /tmp &&
printf "\ncheck whether new nagios-plugins have released.\nEnter to continue." &&
read continue &&
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz &&
tar zxf nagios-plugins.tar.gz &&
cd /tmp/nagios-plugins-release-2.2.1/ &&
./tools/setup &&
./configure &&
make &&
make install
