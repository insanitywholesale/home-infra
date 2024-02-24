#!/bin/bash
set -e

VERSION="0.2.3"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

function agentinstall {
    echo -e "${GREEN}Installing additional packages...${NC}"
    apt-get -qq install -y xinetd libwww-perl
    cp /opt/observium/scripts/observium_agent_xinetd /etc/xinetd.d/observium_agent_xinetd
    service xinetd restart
    cp /opt/observium/scripts/observium_agent /usr/bin/observium_agent
    mkdir -p /usr/lib/observium_agent
    mkdir -p /usr/lib/observium_agent/scripts-available
    mkdir -p /usr/lib/observium_agent/scripts-enabled
    cp -r /opt/observium/scripts/agent-local/* /usr/lib/observium_agent/scripts-available
    chmod +x /usr/bin/observium_agent
    ln -sf /usr/lib/observium_agent/scripts-available/dmi /usr/lib/observium_agent/scripts-enabled
    ln -sf /usr/lib/observium_agent/scripts-available/apache /usr/lib/observium_agent/scripts-enabled
    ln -sf /usr/lib/observium_agent/scripts-available/mysql /usr/lib/observium_agent/scripts-enabled

    echo "\$config['poller_modules']['unix-agent']                   = 1;" >> /opt/observium/config.php
    echo -e "${GREEN}DONE! UNIX-agent is installed and this server is now monitored by Observium${NC}"
}

function snmpdinstall {
  echo -e "${GREEN}Installing snmpd...${NC}"
  apt-get -qq install -y snmpd

  cp /opt/observium/scripts/distro /usr/local/bin/distro
  chmod +x /usr/local/bin/distro
  echo -e "${YELLOW}Reconfiguring local snmpd${NC}"
  echo "agentAddress  udp:127.0.0.1:161" > /etc/snmp/snmpd.conf
  snmpcommunity="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-15};echo;)"
  echo "rocommunity $snmpcommunity" >> /etc/snmp/snmpd.conf

  # Distro sctipt
  echo "# This line allows Observium to detect the host OS if the distro script is installed" >> /etc/snmp/snmpd.conf
  echo "extend .1.3.6.1.4.1.2021.7890.1 distro /usr/local/bin/distro" >> /etc/snmp/snmpd.conf

  # Vendor/hardware extending
  if [ -f "/sys/devices/virtual/dmi/id/product_name" ]; then
    echo "# This lines allows Observium to detect hardware, vendor and serial" >> /etc/snmp/snmpd.conf
    echo "extend .1.3.6.1.4.1.2021.7890.2 hardware /bin/cat /sys/devices/virtual/dmi/id/product_name" >> /etc/snmp/snmpd.conf
    echo "extend .1.3.6.1.4.1.2021.7890.3 vendor   /bin/cat /sys/devices/virtual/dmi/id/sys_vendor" >> /etc/snmp/snmpd.conf
    echo "#extend .1.3.6.1.4.1.2021.7890.4 serial   /bin/cat /sys/devices/virtual/dmi/id/product_serial" >> /etc/snmp/snmpd.conf
  elif [ -f "/proc/device-tree/model" ]; then
    # ARM/RPi specific hardware
    echo "# This lines allows Observium to detect hardware, vendor and serial" >> /etc/snmp/snmpd.conf
    echo "extend .1.3.6.1.4.1.2021.7890.2 hardware /bin/cat /proc/device-tree/model" >> /etc/snmp/snmpd.conf
    echo "#extend .1.3.6.1.4.1.2021.7890.4 serial   /bin/cat /proc/device-tree/serial" >> /etc/snmp/snmpd.conf
  fi

  # Accurate uptime
  echo "# This line allows Observium to collect an accurate uptime" >> /etc/snmp/snmpd.conf
  echo "extend uptime /bin/cat /proc/uptime" >> /etc/snmp/snmpd.conf

  echo "# This line enables Observium's ifAlias description injection" >> /etc/snmp/snmpd.conf
  echo "#pass_persist .1.3.6.1.2.1.31.1.1.1.18 /usr/local/bin/ifAlias_persist" >> /etc/snmp/snmpd.conf
  
  service snmpd restart
  
  echo -e "${YELLOW}Adding localhost to Observium${NC}"
  /opt/observium/add_device.php localhost $snmpcommunity
  echo -e "${GREEN}DONE! UNIX-agent is installed and this server is now monitored by Observium${NC}"
}

if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}ERROR: You must be a root user${NC}" 2>&1
  exit 1
fi

ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')

if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    OS=Debian  # XXX or Ubuntu??
    VER=$(cat /etc/debian_version)
else
    OS=$(uname -s)
    VER=$(uname -r)
fi

if [[ !$OS =~ ^(Ubuntu|Debian)$ ]]; then
    echo -e "${RED} [*] ERROR: This installscript does not support this distro, only Debian or Ubuntu supported. Use the manual guide at https://docs.observium.org/install_rhel7/ ${NC}"
    exit 1
fi

if [ -f /etc/apache2/sites-available/000-default.conf ] || [ -f /etc/apache2/sites-available/default ]; then
    echo -e "${YELLOW}WARNING: Apache default config found, this script will overwrite that config and your current config will be lost${NC}"
    echo "Continue?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes )
                echo "Apache config will be overwritten..."
                break
                ;;
            No )
                echo "Exiting..."
                exit 1
                ;;
        esac
    done
fi

cat << "EOF"
  ___  _                         _
 / _ \| |__  ___  ___ _ ____   _(_)_   _ _ __ ___
| | | | '_ \/ __|/ _ \ '__\ \ / / | | | | '_ ` _ \
| |_| | |_) \__ \  __/ |   \ V /| | |_| | | | | | |
 \___/|_.__/|___/\___|_|    \_/ |_|\__,_|_| |_| |_|
EOF
echo -e ""
echo -e "${GREEN}Welcome to Observium automatic installscript v${VERSION}"
echo -e ""

observ_ver=1

if [ $observ_ver = 4 ]; then
  agentinstall
  exit 1
elif [ $observ_ver = 5 ]; then
  snmpdinstall
  exit 1
fi
echo -e ""
echo "you choose $observ_ver"
echo " "

if [ $observ_ver = 1 ]; then
   echo -e "${BOLD} Requested installing Observium CE${NC}"
   echo -e ""
else
   echo -e "${RED} [*] ERROR: Invalid option $observ_ver${NC}"
   exit 1
fi

echo "Setting MySQL root password"

echo "mysql-server mysql-server/root_password password observium" | debconf-set-selections # TODO: get password from ansible vault
echo "mysql-server mysql-server/root_password_again password observium" | debconf-set-selections # TODO: get password from ansible vault

echo -e "${GREEN} [*] Beginning package installation, this might take up to 30min${NC}"
if [ $OS = "Ubuntu" ] && [ $VER = "16.04" ]; then
   # Unsupported!
   echo -e "${GREEN} [*] We are on Ubuntu 16.04 LTS, installing packages...${NC}"
   apt-get -qq update
   apt-get -qq install -y libapache2-mod-php7.0 php7.0-cli php7.0-mysql php7.0-gd php7.0-mcrypt php7.0-json php7.0-bcmath php7.0-mbstring php7.0-curl php-apcu php-pear snmp fping mysql-server mysql-client python-mysqldb rrdtool subversion whois mtr-tiny ipmitool graphviz imagemagick apache2
   phpenmod mcrypt
   a2dismod mpm_event
   a2enmod mpm_prefork
   a2enmod php7.0
elif [ $OS = "Ubuntu" ] && [ $VER = "14.04" ]; then
   # Unsupported!
   echo -e "${GREEN} [*] We are on Ubuntu 14.04, installing packages...${NC}"
   apt-get -qq update
   apt-get -qq install -y libapache2-mod-php5 php5-cli php5-mysql php5-gd php5-mcrypt php5-json php-pear snmp fping mysql-server mysql-client python-mysqldb rrdtool subversion whois mtr-tiny ipmitool graphviz imagemagick
   php5enmod mcrypt
elif [ $OS = "Ubuntu" ] && [ $VER = "17.04" ]; then
   # Unsupported!
   echo -e "${GREEN} [*] We are on Ubuntu 17.04, installing packages...${NC}"
   apt-get -qq update
   apt-get -qq install -y libapache2-mod-php7.0 php7.0-cli php7.0-mysql php7.0-gd php7.0-mcrypt php7.0-json php7.0-bcmath php7.0-mbstring php7.0-curl php-apcu php-pear snmp fping mysql-server mysql-client python-mysqldb rrdtool subversion whois mtr-tiny ipmitool graphviz imagemagick apache2
   phpenmod mcrypt
   a2dismod mpm_event
   a2enmod mpm_prefork
   a2enmod php7.0
elif [ $OS = "Ubuntu" ] && [ $VER = "17.10" ]; then
   echo -e "${GREEN} [*] We are on Ubuntu 17.10, installing packages...${NC}"
   apt-get -qq update
   apt-get -qq install -y libapache2-mod-php7.1 php7.1-cli php7.1-mysql php7.1-gd php7.1-mcrypt php7.1-json php7.1-bcmath php7.1-mbstring php7.1-opcache php7.1-curl php-apcu php-pear snmp fping mysql-server mysql-client python-mysqldb rrdtool subversion whois mtr-tiny ipmitool libvirt-clients graphviz imagemagick apache2
   phpenmod mcrypt
   a2dismod mpm_event
   a2enmod mpm_prefork
   a2enmod php7.1
elif [ $OS = "Ubuntu" ] && [ $VER = "18.04" ]; then
   echo -e "${GREEN} [*] We are on Ubuntu 18.04 LTS, installing packages...${NC}"
   add-apt-repository universe
   add-apt-repository multiverse
   apt -qq update
   apt -q install -y libapache2-mod-php7.2 php7.2-cli php7.2-mysql php7.2-gd php7.2-json php7.2-bcmath php7.2-mbstring php7.2-opcache php7.2-curl php-apcu php-pear snmp fping mysql-server mysql-client python-mysqldb rrdtool subversion whois mtr-tiny ipmitool libvirt-clients graphviz imagemagick apache2
   #phpenmod mcrypt
   a2dismod mpm_event
   a2enmod mpm_prefork
   a2enmod php7.2
elif [ $OS = "Ubuntu" ] && [ $VER = "20.04" ]; then
   echo -e "${GREEN} [*] We are on Ubuntu 20.04 LTS, installing packages...${NC}"
   add-apt-repository universe
   add-apt-repository multiverse
   apt -qq update
   apt -q install libapache2-mod-php7.4 php7.4-cli php7.4-mysql php7.4-gd php7.4-json php7.4-bcmath php7.4-mbstring php7.4-opcache php7.4-curl php-apcu php-pear snmp fping mysql-server mysql-client rrdtool subversion whois mtr-tiny ipmitool libvirt-clients graphviz imagemagick apache2 python3-mysqldb python3-pymysql python-is-python3
   a2dismod mpm_event
   a2enmod mpm_prefork
   a2enmod php7.4
elif [ $OS = "Ubuntu" ] && [ $VER = "21.04" ]; then
   echo -e "${GREEN} [*] We are on Ubuntu 21.04, installing packages...${NC}"
   echo -e "${YELLOW} [*] Note that we would generally recommend sticking to the most recent Ubuntu LTS release.${NC}"
   add-apt-repository universe
   add-apt-repository multiverse
   apt -qq update
   apt -q install libapache2-mod-php7.4 php7.4-cli php7.4-mysql php7.4-gd php7.4-json php7.4-bcmath php7.4-mbstring php7.4-opcache php7.4-curl php-apcu php-pear snmp fping mysql-server mysql-client rrdtool subversion whois mtr-tiny ipmitool libvirt-clients graphviz imagemagick apache2 python3-mysqldb python3-pymysql python-is-python3
   a2dismod mpm_event
   a2enmod mpm_prefork
   a2enmod php7.4
elif [ $OS = "Ubuntu" ] && [ $VER = "22.04" ]; then
   echo -e "${GREEN} [*] We are on Ubuntu 22.04, installing PHP 8.1 and other packages...${NC}"
   add-apt-repository universe
   add-apt-repository multiverse
   apt -qq update
   apt -q install libapache2-mod-php8.1 php8.1-cli php8.1-mysql php8.1-gd php8.1-bcmath php8.1-mbstring php8.1-opcache php8.1-curl php-apcu php-pear snmp fping mysql-server mysql-client rrdtool subversion whois mtr-tiny ipmitool libvirt-clients graphviz imagemagick apache2 python3-mysqldb python3-pymysql python-is-python3
   a2dismod mpm_event
   a2enmod mpm_prefork
   a2enmod php8.1
elif [ $OS = "Debian" ] && [[ $VER =~ ^8.* ]]; then
   echo -e "${GREEN} [*] We are on Debian 8.x, installing packages...${NC}"
   apt-get -qq update
   apt-get -qq install -y libapache2-mod-php7.0 php7.0-cli php7.0-mysql php7.0-gd php7.0-libsodium php7.0-mcrypt php7.0-json php7.0-bcmath php7.0-mbstring php7.0-opcache php7.0-apcu php7.0-curl php-pear snmp fping mysql-server mysql-client python-mysqldb rrdtool subversion whois mtr-tiny ipmitool graphviz imagemagick apache2
   phpenmod mcrypt
   a2dismod mpm_event
   a2enmod mpm_prefork
   a2enmod php7.0
elif [ $OS = "Debian" ] && [[ $VER =~ ^9.* ]]; then
   # Unsupported!
   echo -e "${GREEN} [*] We are on Debian 9.x, installing packages...${NC}"
   apt-get -qq update
   apt-get -qq install -y libapache2-mod-php7.0 php7.0-cli php7.0-mysql php7.0-gd php7.0-libsodium php7.0-mcrypt php7.0-json php7.0-bcmath php7.0-mbstring php7.0-opcache php7.0-apcu php7.0-curl php-pear snmp fping mariadb-server mariadb-client python-mysqldb rrdtool subversion whois mtr-tiny ipmitool graphviz imagemagick apache2
   phpenmod mcrypt
   a2dismod mpm_event
   a2enmod mpm_prefork
   a2enmod php7.0
elif [ $OS = "Debian" ] && [[ $VER =~ ^10.* ]]; then
   echo -e "${GREEN} [*] We are on Debian 10.x, we will install PHP 7.3. Installing packages...${NC}"
   apt -qq update
   apt -qq install -y libapache2-mod-php7.3 php7.3-cli php7.3-mysql php7.3-gd php7.3-json php7.3-bcmath php7.3-mbstring php7.3-opcache php7.3-apcu php7.3-curl php-pear snmp fping mariadb-server mariadb-client python-mysqldb rrdtool subversion whois mtr-tiny ipmitool libvirt-clients graphviz imagemagick apache2
   #phpenmod mcrypt
   a2dismod mpm_event
   a2enmod mpm_prefork
elif [ $OS = "Debian" ] && [[ $VER =~ ^11.* ]]; then
   echo -e "${GREEN} [*] We are on Debian 11.x, we will install PHP 7.4. Installing packages...${NC}"
   apt -qq update
   apt -qq install -y libapache2-mod-php7.4 php7.4-cli php7.4-mysql php7.4-gd php7.4-json php7.4-bcmath php7.4-mbstring php7.4-opcache php7.4-apcu php7.4-curl php-pear snmp fping mariadb-server mariadb-client python3-mysqldb rrdtool subversion whois mtr-tiny ipmitool libvirt-clients graphviz imagemagick apache2 python-is-python3 python3-pymysql
   a2dismod mpm_event
   a2enmod mpm_prefork
elif [ $OS = "Debian" ] && [[ $VER =~ ^12.* ]]; then
   echo -e "${GREEN} [*] We are on Debian 12.x, we will install PHP 8.2. Installing packages...${NC}"
   apt -qq update
   apt -qq install -y libapache2-mod-php8.2 php8.2-cli php8.2-mysql php8.2-gd php8.2-bcmath php8.2-mbstring php8.2-opcache php8.2-apcu php8.2-curl php-json php-pear snmp fping mariadb-server mariadb-client python3-mysqldb python3-pymysql python-is-python3 rrdtool subversion whois mtr-tiny ipmitool libvirt-clients graphviz imagemagick apache2
   a2dismod mpm_event
   a2enmod mpm_prefork
elif [ $OS = "Debian" ] && [[ $VER =~ ^7.* ]]; then
   # Unsupported!
   echo -e "${GREEN} [*] We are on Debian 7.x, installing packages...${NC}"
   apt-get -qq update
   apt-get -qq install -y libapache2-mod-php5 php5-cli php5-mysql php5-gd php5-mcrypt php5-json php5-apcu php5-curl php-pear snmp fping mysql-server mysql-client python-mysqldb rrdtool subversion whois mtr-tiny ipmitool graphviz imagemagick
   php5enmod mcrypt
else
   echo -e "${RED} [*] ERROR: This installscript does not support this distro, only Debian or Ubuntu supported. Use the manual guide at https://docs.observium.org/install_rhel7/ ${NC}"
   echo "OS:" $OS
   echo "Version:" $VER
   exit 1
fi

echo -e "${GREEN} [*] Creating Observium dir${NC}"
mkdir -p /opt/observium && cd /opt

if [ $observ_ver = 1 ]; then
   echo -e "${GREEN} [*] Downloading Observium CE and unpacking...${NC}"
   wget -r -nv https://www.observium.org/observium-community-latest.tar.gz -O /opt/observium-community-latest.tar.gz
   tar zxf observium-community-latest.tar.gz --checkpoint=.1000
   echo " "
elif [ $observ_ver = 2 ]; then
   echo -e "${GREEN} [*] Checking out Observium Pro/Ent stable from SVN${NC}"
   #echo "Your SVN username and password is found after you login at: https://www.observium.org/subs/"
   #read -p "Please enter your SVN username: " svn_user
   svn co -q --username "$svn_user" --password "$svn_password" https://svn.observium.org/svn/observium/branches/stable observium
elif [ $observ_ver = 3 ]; then
   echo -e "${GREEN} [*] Checking out Observium Pro/Ent rolling from SVN${NC}"
   #echo "Your SVN username and password is found after you login at: https://www.observium.org/subs/"
   #read -p "Please enter your SVN username: " svn_user
   svn co -q --username "$svn_user" --password "$svn_password" https://svn.observium.org/svn/observium/trunk observium
fi

cd observium
echo -e "${GREEN} [*] Creating database user for Observium with a random password...${NC}"
mysql_observium="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-15};echo;)"
mysql_root="observium"
mysql -uroot -p"$mysql_root" -e "CREATE DATABASE observium DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci"

if [[ $OS = "Ubuntu" ]] && ( [[ $VER = "20.04" ]] || [[ $VER = "21.04" ]] || [[ $VER = "22.04" ]] ); then
   #echo -e "${GREEN} [*] We are on Ubuntu 20.04 LTS, installing packages...${NC}"
   mysql -uroot -p"$mysql_root" -e "CREATE USER 'observium'@'localhost' IDENTIFIED BY '$mysql_observium'"
   mysql -uroot -p"$mysql_root" -e "GRANT ALL ON observium.* TO 'observium'@'localhost'"
else
   mysql -uroot -p"$mysql_root" -e "GRANT ALL PRIVILEGES ON observium.* TO 'observium'@'localhost' IDENTIFIED BY '$mysql_observium'"
fi

echo -e "${GREEN} [*] Creating Observium config-file...${NC}"
sed "s/USERNAME/observium/g" config.php.default > /tmp/installscript.tmp
sed "s/PASSWORD/$mysql_observium/g" /tmp/installscript.tmp > config.php
echo -e "${GREEN} [*] Creating log and rrd-directories...${NC}"
mkdir -p logs
# this mode makes all files created inherit permissions of rrd/-folder
mkdir -p --mode=u+rwx,g+rs,o-w rrd
id -u observium &>/dev/null || useradd -G www-data observium
chown -R observium:observium logs
chown -R observium:www-data rrd
chmod -R g+w rrd
./discovery.php -u

apachever="$(apache2ctl -v)"
if [[ $apachever == *"Apache/2.4"* ]]; then
  echo -e "${GREEN} [*] Apache version is 2.4, creating config...${NC}"
  cat > /etc/apache2/sites-available/000-default.conf <<- EOM
  <VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /opt/observium/html
    <FilesMatch \.php$>
      SetHandler application/x-httpd-php
    </FilesMatch>
    <Directory />
            Options FollowSymLinks
            AllowOverride None
    </Directory>
    <Directory /opt/observium/html/>
            DirectoryIndex index.php
            Options Indexes FollowSymLinks MultiViews
            AllowOverride All
            Require all granted
    </Directory>
    ErrorLog  ${APACHE_LOG_DIR}/error.log
    LogLevel warn
    CustomLog  ${APACHE_LOG_DIR}/access.log combined
    ServerSignature On
  </VirtualHost>
EOM
  #echo "$APACHE24" > /etc/apache2/sites-available/000-default.conf
elif [[ $apachever == *"Apache/2.2"* ]]; then
  echo -e "${GREEN} [*] Apache version is 2.2m creating config...${NC}"
  cat > /etc/apache2/sites-available/default <<- EOM
  <VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /opt/observium/html
    <FilesMatch \.php$>
      SetHandler application/x-httpd-php
    </FilesMatch>
    <Directory />
            Options FollowSymLinks
            AllowOverride None
    </Directory>
    <Directory /opt/observium/html/>
            DirectoryIndex index.php
            Options Indexes FollowSymLinks MultiViews
            AllowOverride All
            Order allow,deny
            allow from all
    </Directory>
    ErrorLog  ${APACHE_LOG_DIR}/error.log
    LogLevel warn
    CustomLog  ${APACHE_LOG_DIR}/access.log combined
    ServerSignature On
  </VirtualHost>
EOM
  #echo "$APACHE22" > /etc/apache2/sites-available/default
else
  echo -e "${RED} [*] ERROR: Could not find right version of Apache${NC}"
  exit 1
fi
a2enmod rewrite
apache2ctl restart

echo "Creating first time Observium admin user.."
./adduser.php admin failfail 10 # TODO: get password from ansible vault

echo -e "${GREEN} [*] Creating Observium cronjob...${NC}"
cat > /etc/cron.d/observium <<- EOM
# Run a complete discovery of all devices once every 6 hours
33  */6   * * *   observium   /opt/observium/observium-wrapper discovery >> /dev/null 2>&1
# Run automated discovery of newly added devices every 5 minutes
*/5 *     * * *   observium   /opt/observium/observium-wrapper discovery --host new >> /dev/null 2>&1
# Run multithreaded poller wrapper every 5 minutes
*/5 *     * * *   observium   /opt/observium/observium-wrapper poller >> /dev/null 2>&1

# Run housekeeping script daily for syslog, eventlog and alert log
13 5      * * *   observium   /opt/observium/housekeeping.php -ysel >> /dev/null 2>&1
# Run housekeeping script daily for rrds, ports, orphaned entries in the database and performance data
47 4      * * *   observium   /opt/observium/housekeeping.php -yrptb >> /dev/null 2>&1
EOM

snmpdinstall

echo "Skipping unix-agent installation"

echo -e "${GREEN} [*] Installation finished! Use your webbrowser and login to the web interface with the account you just created and add your first device${NC}"
