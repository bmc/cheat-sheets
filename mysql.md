title: MySQL Cheat Sheet

## Grant all privileges to a database

Prior to MySQL 5:

    GRANT ALL PRIVILEGES ON db_base.* TO db_user @'%' IDENTIFIED BY 'db_passwd'; 

MySQL 5:

    GRANT ALL PRIVILEGES ON db_base.* TO db_user IDENTIFIED BY 'db_passwd'; 

## Create a database

    $ mysqladmin -u root -p create db_name
