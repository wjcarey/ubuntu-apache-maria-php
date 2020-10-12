#!/bin/sh

#SOFTWARE INSTALL
echo "updating linux then installing apache, mariadb, and php ..."
apt update -y && apt upgrade -y && apt install -y git unzip php php-cli php-fpm php-json php-pdo php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-tokenizer php-imagick mariadb-server
echo "success: software install complete ..."

#VARIABLES
echo "gathering arguments from commandline ..."
if [ -z "$1" ]
    then
        echo -e "\e[32mwould you like to configure the database now? [Y/n]"
        read CONFIRM_DATABASE_CONFIGURE

        #USER PROMPT CONFIGURE
        if [ "$CONFIRM_DATABASE_CONFIGURE" != "${CONFIRM_DATABASE_CONFIGURE#[Yy]}" ] ;then
            echo "starting database configuration ..."
            echo -e "\e[32mcreate your database Name ..."
            read DATBASE_NAME
            echo -e "\e[32mcreate your username ..."
            read DATABASE_USER
            echo -e "\e[32mcreate your password for ${DATABASE_USER} ..."
            read DATABASE_PASS
            echo -e "\e[39mdatabase: \e[32m${DATABASE_NAME}\e[39m, user: \e[32m${DATABASE_USER}\e[39m, password: \e[32m${DATABASE_PASS}\e[39m, do you want to continue? [Y/n]"
            read CONFIRM_DATABASE_INSTALL
            if [ "$CONFIRM_DATABASE_INSTALL" != "${CONFIRM_DATABASE_INSTALL#[Yy]}" ] ;then
                mysql -e "DROP USER 'root'@'localhost'; CREATE USER 'root'@'%' IDENTIFIED BY ''; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; CREATE USER '${DATABASE_USER}'@'%' IDENTIFIED BY '${DATABASE_PASS}'; GRANT ALL PRIVILEGES ON *.* TO '${DATABASE_USER}'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
                mysql -e "CREATE DATABASE ${DATBASE_NAME}; FLUSH PRIVILEGES;"
                echo "Success: database complete ..."
            else
                echo "Notice: database configuration exited by user ..."
            fi
        else
            echo "notice: database configuration skipped ..."
        fi
    else
        #ARGUMENT CONFIGURE
        mysql -e "DROP USER 'root'@'localhost'; CREATE USER 'root'@'%' IDENTIFIED BY ''; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; CREATE USER '${3}'@'%' IDENTIFIED BY '${4}'; GRANT ALL PRIVILEGES ON *.* TO '${DATABASE_USER}'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
        mysql -e "CREATE DATABASE ${2}; FLUSH PRIVILEGES;"
        echo "Success: database complete ..."

fi

#SELF DELETE AND EXIT
rm -- "$0"
exit
