#!/bin/sh

#SOFTWARE INSTALL
echo "software install starting ..."
apt update -qq && apt upgrade -qq && apt install -qq git unzip php php-cli php-fpm php-json php-pdo php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-tokenizer php-imagick mariadb-server

#DATABASE CONFIGURE
echo "Would you like to configure the database now? [Y/n]"
read CONFIRM_DATABASE_CONFIGURE
if [ "$CONFIRM_DATABASE_CONFIGURE" != "${CONFIRM_DATABASE_CONFIGURE#[Yy]}" ] ;then
    echo "Create your username ..."
    read DATABASE_USER
    echo "create your password for ${DATABASE_USER} ..."
    read DATABASE_PASS
    echo "create your database Name ..."
    read DATBASE_NAME
    echo "User: ${DATABASE_USER}, Password: ${DATABASE_PASS}, Database: ${DATBASE_NAME}, Do you want to continue? [Y/n]"
    read CONFIRM_DATABASE_INSTALL
    if [ "$CONFIRM_DATABASE_INSTALL" != "${CONFIRM_DATABASE_INSTALL#[Yy]}" ] ;then
        mysql -e "DROP USER 'root'@'localhost'; CREATE USER 'root'@'%' IDENTIFIED BY ''; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; CREATE USER '${DATABASE_USER}'@'%' IDENTIFIED BY '${DATABASE_PASS}'; GRANT ALL PRIVILEGES ON *.* TO '${DATABASE_USER}'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
        mysql -e "CREATE DATABASE ${DATBASE_NAME}; FLUSH PRIVILEGES;"
        echo "Success: database complete ..."
    else
        echo "Error: database configuration skipped"
    fi
else
    echo "Warning: database configuration incomplete"
fi

#APACHE-PHP MODIFY CONFIG
a2enmod rewrite expires headers
sed -i '0,/AllowOverride None/s//AllowOverride All/; 2,/AllowOverride None/s//AllowOverride All/; 0,/Require all denied/s//Require all granted/' /etc/apache2/apache2.conf
printf "\n#Remove Server Tokens\nServerTokens Prod\n#Remove server signature\nServerSignature Off" >> /etc/apache2/apache2.conf
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 1G/g;s/post_max_size = 8M/post_max_size = 1G/g;s/memory_limit = 128M/memory_limit = 512M/g;s/max_execution_time = 30/max_execution_time = 300/g;s/max_input_time = 60/max_input_time = 300/g;' /etc/php/7.4/apache2/php.ini
systemctl restart apache2

rm -- "$0"
exit
