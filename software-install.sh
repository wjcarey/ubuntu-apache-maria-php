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

rm -- "$0"
exit
