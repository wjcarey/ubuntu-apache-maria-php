# ubuntu-apache-maria-php

### Run this code below to execute the script and install software for apache2, mariadb, and php
~~~
sudo curl -o ubuntu-apache-maria-php.sh https://raw.githubusercontent.com/wjcarey/ubuntu-apache-maria-php/master/ubuntu-apache-maria-php.sh && sudo chmod 777 ubuntu-apache-maria-php.sh && sudo ./ubuntu-apache-maria-php.sh
~~~

## Database Arguments can be passed into this command (currently you must use all three)
1 = database name
2 = sql username
3 = sql password

### Example script with defaule values added (default, admin, password)
~~~
sudo curl -o ubuntu-apache-maria-php.sh https://raw.githubusercontent.com/wjcarey/ubuntu-apache-maria-php/master/ubuntu-apache-maria-php.sh && sudo chmod 777 ubuntu-apache-maria-php.sh && sudo ./ubuntu-apache-maria-php.sh new_database admin password
~~~