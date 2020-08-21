#!/bin/bash

apt-get update
apt-get install -y curl wget vim dialog software-properties-common


add-apt-repository ppa:ondrej/php -y
apt-get update
apt-get install php5.6 php5.6-dev php5.6-xml php5.6-mysql php5.6-gd -y --allow-unauthenticated

curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

#Download appropriate package for the OS version
#Choose only ONE of the following, corresponding to your OS version

#Ubuntu 20.04
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list)"
apt-get update

ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-server
# optional: for bcp and sqlcmd
ACCEPT_EULA=Y apt-get install -y mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
# optional: for unixODBC development headers
apt-get install -y unixodbc-dev

pecl install sqlsrv
pecl install pdo_sqlsrv

printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini
printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini

phpenmod sqlsrv pdo_sqlsrv

apt-get install libapache2-mod-php5.6 apache2
a2dismod mpm_event
a2enmod mpm_prefork
a2enmod php5.6
