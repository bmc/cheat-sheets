---
title: MySQL Cheat Sheet
layout: cheat-sheet
---

# Create a database

Using default system encoding:

    $ mysql -u root
    mysql> create database db_name;

Specifying encoding:

    $ mysql -u root
    mysql> create database db_name character set utf8;

# Grant all privileges to a database

Prior to MySQL 5:

    GRANT ALL PRIVILEGES ON db_base.* TO db_user @'%' IDENTIFIED BY 'db_passwd'; 

MySQL 5:

    GRANT ALL PRIVILEGES ON db_base.* TO db_user IDENTIFIED BY 'db_passwd'; 

# Recovering the database root password

First, stop the MySQL server. e.g., On a Debian-like system:

    $ sudo /etc/init.d/mysql stop

Next, bring the server back up with `--skip-grant-tables`:

    $ sudo mysqld_safe --skip-grant-tables &

Connect as `root` and reset the password:

    $ mysql -u root
    Welcome to ...
    mysql> use mysql;
    mysql> update user set password=PASSWORD("new-root-pw") where User='root';
    mysql> flush privileges;
    mysql> ^D

Kill and restart the server:

    $ sudo killall -TERM mysqld_safe
    $ sudo /etc/init.d/mysql start
